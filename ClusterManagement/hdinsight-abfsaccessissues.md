# I can't access files in DataLake Gen2 storage account from my cluster

####ACL verification failed on files/folders
#####Error message :
~~~
LISTSTATUS failed with error 0x83090aa2 (Forbidden. ACL verification failed. Either the resource does not exist or the user is not authorized to perform the requested operation.).
~~~
##### Probable reason :
If the error message indicates forbidden access, the user might have revoked permissions of service principal(SP) on files/folders.

##### Resolution steps :
1. Check that the Managed Identity has 'Storage Blob Data Owner' role assigned to the storage account.
2. Sample dfs command to check access to files/folders in datalake storage account
	~~~
	hdfs --loglevel DEBUG dfs -ls
	~~~
####Managed Identity revoked or deleted
#####Error message :
~~~
Token Refresh failed - Received invalid http response: 500
~~~
##### Probable reason :
The certificate provided for Service principal access might have expired.
1. SSH into headnode. Check access to storage account using following dfs command
~~~
hdfs --loglevel DEBUG dfs -ls
~~~
2. Confirm that the error message is similar to the following
~~~
{"stderr": "-ls: Token Refresh failed - Received invalid http response: 500, text = Response{protocol=http/1.1, code=500, message=Internal Server Error, url=http://gw0-abccluster.24ajrd4341lebfgq5unsrzq0ue.fx.internal.cloudapp.net:909/api/oauthtoken}}...
~~~
3. Get one of the url from core-site.xml property - **fs.azure.datalake.token.provider.service.urls**
4. Run the following curl command to retrieve OAuth token (from standard aka non-secure cluster).
~~~
curl gw0-abccluster.24ajrd4341lebfgq5unsrzq0ue.fx.internal.cloudapp.net:909/api/oauthtoken
~~~
5. The output for a valid service principal should be something like
~~~
{"AccessToken":"MIIGHQYJKoZIhvcNAQcDoIIGDjCCBgoCAQA…….","ExpiresOn":1500447750098}
~~~
6. If the managed identity has been deleted or revoked, the output will look something like this.
~~~
Exception in OAuthTokenController.GetOAuthToken: 'System.InvalidOperationException: Error while getting the OAuth token from AAD for AppPrincipalId b137770e-6749-4179-bddd-05170890fb3a, ResourceUri https://storage.azure.com/, AADTenantId https://login.windows.net/1231d71c-c6b6-47b0-803c-0f3b32b07556, ClientCertificateThumbprint 9815925141D91BA872ABD39711237F577982D77D ---> Microsoft.IdentityModel.Clients.ActiveDirectory.AdalServiceException: AADSTS700016: Application with identifier 'b137770e-6749-4179-bddd-05170890fb3a' was not found in the directory '1234d71c-c6b6-47b0-803c-0f3b32b07556'. This can happen if the application has not been installed by the administrator of the tenant or consented to by any user in the tenant. You may have sent your authentication request to the wrong tenant.
Trace ID: 72836cd9-7b2f-4151-aeb9-a81e1c330b00
Correlation ID: 741b874b-96c7-4c34-a94a-2c16e8f089ff
Timestamp: 2019-08-28 23:59:57Z ---> System.Net.WebException: The remote server returned an error: (400) Bad Request.
   at System.Net.HttpWebRequest.GetResponse()
   at Microsoft.IdentityModel.Clients.ActiveDirectory.HttpWebRequestWrapper.<GetResponseSyncOrAsync>d__2.MoveNext()
~~~

7. Any other Azure Active Directory related errors/certificate related errors can be recognized through the errors retuned in the hdfs command, run in debug mode
