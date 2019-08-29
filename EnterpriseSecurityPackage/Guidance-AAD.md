### AAD policies
* Disable conditional access policy using the IP address based policy
  * This requires service endpoints to be enabled on the VNETs where the clusters are deployed
  * If you use an external service for MFA (something other than AAD), the IP address based policy won't work
* AllowCloudPasswordValidation policy is required for federated isers
  * Since HDI uses the username / password directly to get tokens from AAD, this policy has to be enabled for all federated users

### AAD Groups
* Always deploy clusters with a group
* Use AAD to do manage group memberships (easier than trying to manage the individual services in the cluster)
* Read about [how LDAP group sync works](https://github.com/hdinsight/hdinsight.github.io/blob/master/EnterpriseSecurityPackage/LdapUserSync.md) in HDI

### User accounts
* Use an unique user account for each scenario
  * Like, use an account for import, use another for query or other processing jobs
* Use group based Ranger policies instead of individual policies
* Have a plan on how to manage users who shouldn't have access to clusters anymore
