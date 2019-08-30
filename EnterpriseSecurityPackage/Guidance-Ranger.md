### Ranger policies
* By default, Ranger uses 'Deny' as the policy
* When data access is made through a service where authorization is enabled
  * Ranger authorization plugin is invoked and given the context of the request
  * Ranger applies the policies configured for the service
  * If the Ranger policies fail, the access check is deferred to the file system
    * Some services like MapReduce only check if the file / folder being owned by the same user who is submitting the request
    * Services like Hive, check for either ownership match or appropriate filesystem permissions (rwx)

### What token is used for storage access?
* If the storage type is WASB, then no OAuth token is involved
* If Ranger has performed the authorization, then the storage access happens using the Managed Identity
* If Ranger didn't perform any authorization, then the storage access happens using the user's OAuth token

### What happens when Hierarchical Name Space (HNS) is not enabled in ABFS?
* Since there is no filesystem without HNS, there are no inherited permissions
* Only filesystem permission that works is "Storage Data XXXX" RBAC role, to be assigned to the user directly in Azure Portal

### Other details
* Policies can be applied to groups (preferrable) instead of individuals
* Ranger audit logs are available in HDFS and Solr

### Default HDFS permissions
* By default, only root has access to the / folder
* For the staging directory for mapreduce and others, an user specific directory is created and we provide sticky _wx permissions. 
  * Users can create files and folders underneath, but cannot look at other stuff
  
### How does URL auth work in Ranger?
* If the url auth is enabled
  * Then the config will contain what prefixes are covered in the url auth (like adl://)
  * If the access is for this url, then Ranger will check if the user is in the allow list
  * Ranger will not check any of the fine grained policies
  
### Ranger policies for Hive
* For DDL, in addition to having the permissions to do Create / Update / Delete permissions, the user should have rwx permissions on the directory on storage and all its sub directories
