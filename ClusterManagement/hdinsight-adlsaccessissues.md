# I am unable to access files in DataLake storage account from my cluster

####ACL verification failed on files/folders
#####Error message :
~~~
LISTSTATUS failed with error 0x83090aa2 (Forbidden. ACL verification failed. Either the resource does not exist or the user is not authorized to perform the requested operation.).
~~~
##### Probable reason :
If the error message indicates forbidden access, the user might have revoked permissions of service principal(SP) on files/folders.

##### Resolution steps :
1. Check that the SP has ‘x’ permissions to traverse along the path. For more information see [here](../ClusterCRUD/ADLS/adls-create-permission-setup.md)
2. Sample dfs command to check access to files/folders in datalake storage account
	~~~
	hdfs dfs -ls /<path to check access>
	~~~
3. Set up required permissions to access the path based on the read/write operation being performed. See [here](https://docs.microsoft.com/en-us/azure/data-lake-store/data-lake-store-access-control) for permissions required for various file system operations.


####Service principal certificate expiry
#####Error message :
~~~
Token Refresh failed - Received invalid http response: 500
~~~
##### Probable reason :
The certificate provided for Service principal access might have expired.
1. SSH into headnode. Check access to storage account using following dfs command
~~~
hdfs dfs -ls /
~~~
2. Confirm that the error message is similar to the following
~~~
{"stderr": "-ls: Token Refresh failed - Received invalid http response: 500, text = Response{protocol=http/1.1, code=500, message=Internal Server Error, url=http://gw0-abccluster.24ajrd4341lebfgq5unsrzq0ue.fx.internal.cloudapp.net:909/api/oauthtoken}}...
~~~
3. Get one of the url from core-site.xml property - **fs.azure.datalake.token.provider.service.urls**
4. Run the following curl command to retrieve OAuth token.
~~~
curl gw0-abccluster.24ajrd4341lebfgq5unsrzq0ue.fx.internal.cloudapp.net:909/api/oauthtoken
~~~
5. The output for a valid service principal should be something like
~~~
{"AccessToken":"MIIGHQYJKoZIhvcNAQcDoIIGDjCCBgoCAQA…….","ExpiresOn":1500447750098}
~~~
6. If the service principal certificate has expired, the output will look something like this.
~~~
Exception in OAuthTokenController.GetOAuthToken: 'System.InvalidOperationException: Error while getting the OAuth token from AAD for AppPrincipalId 23abe517-2ffd-4124-aa2d-7c224672cae2, ResourceUri https://management.core.windows.net/, AADTenantId https://login.windows.net/80abc8bf-86f1-41af-91ab-2d7cd011db47, ClientCertificateThumbprint C49C25705D60569884EDC91986CEF8A01A495783 ---> Microsoft.IdentityModel.Clients.ActiveDirectory.AdalServiceException: AADSTS70002: Error validating credentials. AADSTS50012: Client assertion contains an invalid signature. **[Reason - The key used is expired.**, Thumbprint of key used by client: 'C49C25705D60569884EDC91986CEF8A01A495783', Found key 'Start=08/03/2016, End=08/03/2017, Thumbprint=C39C25705D60569884EDC91986CEF8A01A4956D1', Configured keys: [Key0:Start=08/03/2016, End=08/03/2017, Thumbprint=C39C25705D60569884EDC91986CEF8A01A4956D1;]]
Trace ID: e4d34f1c-a584-47f5-884e-1235026d5000
Correlation ID: a44d870e-6f23-405a-8b23-9b44aebfa4bb
Timestamp: 2017-10-06 20:44:56Z ---> System.Net.WebException: The remote server returned an error: (401) Unauthorized.
at System.Net.HttpWebRequest.GetResponse()
at Microsoft.IdentityModel.Clients.ActiveDirectory.HttpWebRequestWrapper.<GetResponseSyncOrAsync>d__2.MoveNext()
~~~
7. Any other Azure Active Directory related errors/certificate related errors can be recognized by pinging the gateway url to get the OAuth token.

##### Resolution steps :
If the certificate has expired, drop the existing cluster and re-create it.