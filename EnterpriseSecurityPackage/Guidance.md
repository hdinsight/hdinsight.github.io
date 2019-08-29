### Summary
When deoploy a secure HDI cluster, there are some best practices that should make the deployment and cluster management easier. We will outline them here.

### When do you need a secure cluster?
* Cluster will be used by multiple users at the same time
* Users have different levels of access to the same data

### When NOT to use a secure cluster?
* If you are going to run only automated jobs (like single user account), a standard cluster is good enough
* You can do all the data import using a standard cluster and use the same storage account on a different secure cluster where users can run analytics jobs

### Guidance on individual components
* [AAD DS](https://github.com/hdinsight/hdinsight.github.io/blob/master/EnterpriseSecurityPackage/Guidance-AADDS.md)
* [AAD](https://github.com/hdinsight/hdinsight.github.io/blob/master/EnterpriseSecurityPackage/Guidance-AAD.md)
* [Azure Resources](https://github.com/hdinsight/hdinsight.github.io/blob/master/EnterpriseSecurityPackage/Guidance-AzureResources.md)

### How does HDI bring OAuth and Kerberos together
* All the storage requests require OAuth access tokens
* All the Hadoop services require Kerberos tickets or delegation tokens
* HDI Gateway, as a part of single sign on, will register the OAuth access tokens in credential service and will attach Kerberos ticket before forwarding it to the downstream service
* Storage drivers are configured to call the credential service with Kerberos tickets and get the OAuth tokens

### Storage
* ABFS with HNS enabled (HNS provides a file system, with hierarchy and ACLs required for secure clusters)
* With WASB, there are no OAuth tokens involved. Access keys are used.
    * Anyone with HDFS access can access all the files.

### Ranger policies
* In general, if there is a Ranger policy defined for a service, then it is applied, else the filesytem ACLs are checked for access
* By default, all policies are set to deny
* There are no Ranger policies for HDFS. All other services are supported
* Ranger policies are supported for Hive, Livy, HBase, Kafka and others
    * Ranger policies are not supported for HDFS
    * When accessing the storage using HDFS directly, the storage access is done as the user
* Policies can be applied to groups (preferrable) instead of individuals
* Ranger audit logs are available in HDFS and Solr

### You have tried creating a secure cluster unsuccessfully a few times, how to get there faster?
* For domain join issues, spin up a Ubuntu VM and domain join the VM using this [documentation](https://github.com/hdinsight/hdinsight.github.io/blob/master/EnterpriseSecurityPackage/DomainJoinIssues.md)

### Performance impact
* Ranger authorizer will evaluate all Ranger policies for that service for each request
* This could have an impact on the time take to accept the job or query
* Spark SQL authorizer LLAP (Hive based policies) for authorization. LLAP is allocated roughly 50% of the capacity. If you do not use spark sql, you can reclaim this.

### SSH access
* Refer to this doc for [how to configure](https://github.com/hdinsight/hdinsight.github.io/blob/master/EnterpriseSecurityPackage/SshUsingDomainAccounts.md)

### Using local accounts in a secure cluster
* If you use a shared user account or a local account, then it will be hard to tell who used the account to change the config or service
* It is also a problematic area when users are no longer part of the organization
