### Summary
When deoploy a secure HDI cluster, there are some best practices that should make the deployment and cluster management easier. We will outline them here.

### When do you need a secure cluster?
* Cluster will be used by multiple users at the same time
* Users have different levels of access to the same data

### When NOT to use a secure cluster?
* If you are going to run only automated jobs (like single user account), a standard cluster is good enough
* You can do all the data import using a standard cluster and use the same storage account on a different secure cluster where users can run analytics jobs

### Why do we need AAD DS?
* Secure clusters require domain joining
* Depending on on-premise domain controllers creates from the cloud creates stability issues

### AAD DS instance
* Create the instance with the .onmicrosoft.com domain. This way, there won't be multiple DNS servers for the domain
* Create a self-signed certificate
* Use a peered vnet for deploying clusters (when you have a number of teams deploying HDI ESP clusters, this will be helpful)
* Configure the DNS for the VNETs properly (the AAD DS domain name should resolve without any hosts file entries)
* If you are using NSGs make sure that you have read through the [firewall support in HDI](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-restrict-outbound-traffic)

### Understand how password hash sync works
* Only non reversible password hashes are synced
* On-premise to AAD has to be enabled through AD Connect
* AAD to AAD DS sync is automatic (latencies are under 20 minutes)
* Password hashes are synced only when there is a change password
  * When you enable password hash sync, all existing passwords do not get synced automatically as they are stored irreversibly
  * When you change the password, password hashes get synced

### How does multiple domains work in HDI
* AAD DS (domain controllers) support a single REALM
* AAD supports multiple verified domains
* Let us say your AAD DS realm is CONTOSO.ONMICROSOFT.com
* Let us say the userPrincipalName in AAD is bob@contoso.com
* Let us say the sAMAccountName in AAD DS for this user is 'bob'
* Kerberos tickets will be issued for bob@CONTOSO.ONMICROSOFT.com
* AAD Oauth tokens will have UPN as bob@contoso.com

### How does HDI bring OAuth and Kerberos together
* All the storage requests require OAuth access tokens
* All the Hadoop services require Kerberos tickets or delegation tokens
* HDI Gateway, as a part of single sign on, will register the OAuth access tokens in credential service and will attach Kerberos ticket before forwarding it to the downstream service
* Storage drivers are configured to call the credential service with Kerberos tickets and get the OAuth tokens

### AAD policies
* Disable conditional access policy using the IP address based policy
  * This requires service endpoints to be enabled on the VNETs where the clusters are deployed
  * If you use an external service for MFA (something other than AAD), the IP address based policy won't work
* AllowCloudPasswordValidation policy is required for federated isers
  * Since HDI uses the username / password directly to get tokens from AAD, this policy has to be enabled for all federated users

### Resource groups
* Use a new resource group for each cluster so that you can distinguish between cluster resources

### AAD Groups
* Always deploy clusters with a group
* Use AAD to do manage group memberships (easier than trying to manage the individual services in the cluster)
* Read about [how LDAP group sync works](https://github.com/hdinsight/hdinsight.github.io/blob/master/EnterpriseSecurityPackage/LdapUserSync.md) in HDI

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

### What is the best way to inspect the properties of users in AAD DS?
* Using a windows VM joined to the [AAD DS domain](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/manage-domain)
* If you have successfully deployed a cluster, you can use one of the head nodes to inspect properties (net ads search commands)

### Where are the computer objects located in AAD DS?
* Each cluster is associated with a single OU
* We provision an internal user in this OU for this cluster
* We domain join all the nodes (head nodes, worker nodes, egde nodes, zookeeper nodes) into the same OU.

### Performance impact
* Ranger authorizer will evaluate all Ranger policies for that service for each request
* This could have an impact on the time take to accept the job or query
* Spark SQL authorizer LLAP (Hive based policies) for authorization. LLAP is allocated roughly 50% of the capacity. If you do not use spark sql, you can reclaim this.

### SSH access
* Refer to this doc for [how to configure](https://github.com/hdinsight/hdinsight.github.io/blob/master/EnterpriseSecurityPackage/SshUsingDomainAccounts.md)

### Using local accounts in a secure cluster
* If you use a shared user account or a local account, then it will be hard to tell who used the account to change the config or service
* It is also a problematic area when users are no longer part of the organization
