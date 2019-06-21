### **Problem**:
On secure clusters backed by Azure Datalake (Gen1 or Gen2), when domain users sign into the cluster services through HDI Gateway (like signing in to the Ambari portal), HDI Gateway will try to obtain an OAuth token from AAD first and then get a kerberos ticket from AAD DS. Authentication may fail in either of these stages. This document is aimed at debugging some of those issues.

### **Details of authentication**:
HDInsight Gateway challenges the client for user name and password through a basic authentication challenge. After obtaining the username and password, HDInsight gateway sends the username and password to AAD first to get an OAuth token. This is done using OAuth [ROPC](https://docs.microsoft.com/en-us/azure/active-directory/develop/v2-oauth-ropc). This is an background token acquisition request. Once this succeeds, HDInsight Gateway registers the refresh token in the credetial service. HDInsight Gateway then obtains a kerberos ticket for the ServicePrincipalName required by the upstream service. HDInsight attaches the Kerberos ticket to the request (replaces the incoming basic authentication credentials with the Kerberos ticket) and forwards the request to the upstream service.

### **Details of the error messages**:
When the authentication fails, you will get reprompted for credentials. If you cancel this, the error message will be printed. Here are some of the popular error messages

### invalid_grant

invalid_grant error code is a generic error code. You need to look at the inner error code to root cause it.
[AAD Error codes](https://docs.microsoft.com/en-us/azure/active-directory/develop/reference-aadsts-error-codes)
   
1.  Login fails for federated users with error code 50126 (login succeeds for cloud users)
   
   Reason: Bad Request, Detailed Response: {"error":"invalid_grant","error_description":"AADSTS70002: 
    Error validating credentials. AADSTS50126: Invalid username or password\r\nTrace ID: 09cc9b95-4354-46b7-91f1-efd92665ae00\r\n
    Correlation ID: 4209bedf-f195-4486-b486-95a15b70fbe4\r\nTimestamp: 2019-01-28 17:49:58Z","error_codes":[70002,**50126**],
    "timestamp":"2019-01-28 17:49:58Z","trace_id":"09cc9b95-4354-46b7-91f1-efd92665ae00","correlation_id":"4209bedf-f195-4486-b486-95a15b70fbe4"}
    
AAD error code 50126 means the AllowCloudPasswordValidation policy has not been set by the tenant. The Company Administrator
    of the AAD tenant should run the following commands to enable AAD to use password hashes for ADFS backed users.

[HDInsight documentation](https://docs.microsoft.com/en-us/azure/hdinsight/domain-joined/apache-domain-joined-architecture#set-up-different-domain-controllers)

[AAD's documentation](https://docs.microsoft.com/en-us/azure/active-directory/manage-apps/configure-authentication-for-federated-users-portal)

2. Login fails with error code 50034
   
   {"error":"invalid_grant","error_description":"AADSTS50034: The user account Microsoft.AzureAD.Telemetry.Diagnostics.PII does not exist in the
    0c349e3f-1ac3-4610-8599-9db831cbaf62 directory. To sign into this application, the account must be added to the directory.\r\nTrace ID: 
    bbb819b2-4c6f-4745-854d-0b72006d6800\r\nCorrelation ID: b009c737-ee52-43b2-83fd-706061a72b41\r\nTimestamp: 2019-04-29 15:52:16Z",
    "error_codes":[50034],"timestamp":"2019-04-29 15:52:16Z","trace_id":"bbb819b2-4c6f-4745-854d-0b72006d6800",
    "correlation_id":"b009c737-ee52-43b2-83fd-706061a72b41"}

    User name is incorrect (does not exist). The user is not using the same username that s/he uses in azure portal. Please try signing in to https://portal.azure.com and use the same user name that works in that portal.

3. User account is locked out, error code 50053
   
{"error":"unauthorized_client","error_description":"AADSTS50053: You've tried to sign in too many times with an incorrect user ID or password.\r\nTrace ID: 844ac5d8-8160-4dee-90ce-6d8c9443d400\r\nCorrelation ID: 23fe8867-0e8f-4e56-8764-0cdc7c61c325\r\nTimestamp: 2019-06-06 09:47:23Z","error_codes":[50053],"timestamp":"2019-06-06 09:47:23Z","trace_id":"844ac5d8-8160-4dee-90ce-6d8c9443d400","correlation_id":"23fe8867-0e8f-4e56-8764-0cdc7c61c325"}

Wait for 30 minutes or so, stop any applications that might be trying to authenticate.

4. Password expired,  error code 50053

 {"error":"user_password_expired","error_description":"AADSTS50055: Password is expired.\r\nTrace ID: 241a7a47-e59f-42d8-9263-fbb7c1d51e00\r\nCorrelation ID: c7fe4a42-67e4-4acd-9fb6-f4fb6db76d6a\r\nTimestamp: 2019-06-06 17:29:37Z","error_codes":[50055],"timestamp":"2019-06-06 17:29:37Z","trace_id":"241a7a47-e59f-42d8-9263-fbb7c1d51e00","correlation_id":"c7fe4a42-67e4-4acd-9fb6-f4fb6db76d6a","suberror":"user_password_expired","password_change_url":"https://portal.microsoftonline.com/ChangePassword.aspx"}
 
 Change the password in the azure portal (on on your on-premise system) and then wait for 30 minutes for sync to catch up.
 
 ### interaction_required
 
 This means conditional access policy or MFA is being applied to the user. Since interactive authentication is not
supported yet, the user or the cluster needs to be exempted from MFA / Conditional access. If you choose to exempt
the cluster (IP address based exemption policy), then make sure that the AD ServiceEndpoints are enabled for that vnet.

[Official documentation](https://docs.microsoft.com/en-us/azure/hdinsight/domain-joined/apache-domain-joined-configure-using-azure-adds)

### LogonDenied

Kerberos authentication has failed, it could be because of password hashes out of sync, account locked out in AAD DS etc... You will need to try to authenticate (kinit) using the same user credentials, from a machine that is joined to the domain. You can try this by SSHing into the head / edge node.
