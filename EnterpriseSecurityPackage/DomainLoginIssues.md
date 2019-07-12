### **Problem**:
On secure clusters backed by Azure Datalake (Gen1 or Gen2), when domain users sign into the cluster services through HDI Gateway (like signing in to the Ambari portal), HDI Gateway will try to obtain an OAuth token from AAD first and then get a kerberos ticket from AAD DS. Authentication may fail in either of these stages. This document is aimed at debugging some of those issues.

### **Details of the error messages**:
When the authentication fails, you will get reprompted for credentials. If you cancel this dialog, the error message will be printed. Here are some of the common error messages

### invalid_grant or unauthorized_client

invalid_grant error code is a generic error code. You need to look at the inner error code to root cause it.
[AAD Error codes](https://docs.microsoft.com/en-us/azure/active-directory/develop/reference-aadsts-error-codes)
   
1.  Login fails for federated users with error code 50126 (login succeeds for cloud users)
   
   Reason: Bad Request, Detailed Response: {"error":"invalid_grant","error_description":"AADSTS70002: 
    Error validating credentials. AADSTS50126: Invalid username or password\r\nTrace ID: 09cc9b95-4354-46b7-91f1-efd92665ae00\r\n
    Correlation ID: 4209bedf-f195-4486-b486-95a15b70fbe4\r\nTimestamp: 2019-01-28 17:49:58Z","error_codes":[70002,**50126**],
    "timestamp":"2019-01-28 17:49:58Z","trace_id":"09cc9b95-4354-46b7-91f1-efd92665ae00","correlation_id":"4209bedf-f195-4486-b486-95a15b70fbe4"}
    
AAD error code 50126 means the AllowCloudPasswordValidation policy has not been set by the tenant. The Company Administrator
    of the AAD tenant should run the following commands to enable AAD to use password hashes for ADFS backed users.

Resolution: Apply the AllowCloudPasswordValidationPolicy as described in the documents below.
[HDInsight documentation](https://docs.microsoft.com/en-us/azure/hdinsight/domain-joined/apache-domain-joined-architecture#set-up-different-domain-controllers)

[AAD's documentation](https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/configure-authentication-for-federated-users-portal)

2. Login fails with error code 50034
   
   {"error":"invalid_grant","error_description":"AADSTS50034: The user account Microsoft.AzureAD.Telemetry.Diagnostics.PII does not exist in the
    0c349e3f-1ac3-4610-8599-9db831cbaf62 directory. To sign into this application, the account must be added to the directory.\r\nTrace ID: 
    bbb819b2-4c6f-4745-854d-0b72006d6800\r\nCorrelation ID: b009c737-ee52-43b2-83fd-706061a72b41\r\nTimestamp: 2019-04-29 15:52:16Z",
    "error_codes":[50034],"timestamp":"2019-04-29 15:52:16Z","trace_id":"bbb819b2-4c6f-4745-854d-0b72006d6800",
    "correlation_id":"b009c737-ee52-43b2-83fd-706061a72b41"}	

Resolution: User name is incorrect (does not exist). The user is not using the same username that s/he uses in azure portal. Please try signing in to https://portal.azure.com and use the same user name that works in that portal.

3. User account is locked out, error code 50053
   
{"error":"unauthorized_client","error_description":"AADSTS50053: You've tried to sign in too many times with an incorrect user ID or password.\r\nTrace ID: 844ac5d8-8160-4dee-90ce-6d8c9443d400\r\nCorrelation ID: 23fe8867-0e8f-4e56-8764-0cdc7c61c325\r\nTimestamp: 2019-06-06 09:47:23Z","error_codes":[50053],"timestamp":"2019-06-06 09:47:23Z","trace_id":"844ac5d8-8160-4dee-90ce-6d8c9443d400","correlation_id":"23fe8867-0e8f-4e56-8764-0cdc7c61c325"}

Resolution: Wait for 30 minutes or so, stop any applications that might be trying to authenticate.

4. Password expired,  error code 50053

 {"error":"user_password_expired","error_description":"AADSTS50055: Password is expired.\r\nTrace ID: 241a7a47-e59f-42d8-9263-fbb7c1d51e00\r\nCorrelation ID: c7fe4a42-67e4-4acd-9fb6-f4fb6db76d6a\r\nTimestamp: 2019-06-06 17:29:37Z","error_codes":[50055],"timestamp":"2019-06-06 17:29:37Z","trace_id":"241a7a47-e59f-42d8-9263-fbb7c1d51e00","correlation_id":"c7fe4a42-67e4-4acd-9fb6-f4fb6db76d6a","suberror":"user_password_expired","password_change_url":"https://portal.microsoftonline.com/ChangePassword.aspx"}
 
 Change the password in the azure portal (on on your on-premise system) and then wait for 30 minutes for sync to catch up.
 
 ### interaction_required
 
 This means conditional access policy or MFA is being applied to the user. Since interactive authentication is not
supported yet, the user or the cluster needs to be exempted from MFA / Conditional access. If you choose to exempt
the cluster (IP address based exemption policy), then make sure that the AD ServiceEndpoints are enabled for that vnet.

Resolutiion: Use conditional access policy and extempt the HDInisght clusters from MFA using the following document.
[Official documentation](https://docs.microsoft.com/en-us/azure/hdinsight/domain-joined/apache-domain-joined-configure-using-azure-adds)

### LogonDenied

To get to this stage, your OAuth authentication is not an issue, but Kerberos authenication is. If this cluster is backed by ADLS, OAuth login has succeeded before Kerberos auth is attempted. On WASB clusters, OAuth login is not attempted. There could be many reasons for Kerberos failure - like password hashes are out of sync, user account locked out in AAD DS etc... Password hashes sync only when the user changes password - when you create the AAD DS instance, it will start syncing passwords that are changed after the creation (not retroactively sync passwords that were set before its inception). 

Resolution: 
1. If you think passwords may not be un sync, try changing the password and wait for a few minutes to sync. 
2. Try to SSH into a You will need to try to authenticate (kinit) using the same user credentials, from a machine that is joined to the domain. SSH into the head / edge node with a local user and then run kinit. Look at kinit section for more details

### kinit fails
For kinit to succeed, you need to know your sAMAccountName (this is the short account name without the realm). sAMAccountName is usually the account prefix (like bob in bob@contoso.com). For some users it could be different. You will need the ability to browse / search the directory to learn your sAMAccountName. 

Ways to find my sAMAccountName: 
1. If you can login to Ambari using the local Ambari admin, look at the list of users.
2. If you have a domain joined windows machine [AAD DS Documentation](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/manage-domain), you can use the standard Windows AD tools to browse. This requries a working account in the domain.
3. From the head node, you can use SAMBA commands to search. This requires a valid kerberos session (successful kinit). net ads search "(userPrincipalName=bob*)"

The search / browse results should show you the sAMAccountName attribute. Also, you could look at other attributes like pwdLastSet, badPasswordTime, userPrincipalName etc... to see if those properties match what you expect.

### kinit fails with Preauthentication failure
This implies the username or password is incorrect.

### Job / HDFS command fails due to TokenNotFoundException
This implies that the required OAuth access token was not found / registered for the job / command to succeed. Ensure that you have successfully logged in to the Ambari portal once through the username whose identity is used to run the job.
