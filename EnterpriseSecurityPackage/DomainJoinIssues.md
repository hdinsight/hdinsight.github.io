### Symptom:
HDI Secure (Enterprise Security Package) cluster fails to deploy as the domain join fails

### Explanation of failure:
When the domain joined clusters are deployed, HDI creates an internal user name and password in AAD DS (for each cluster) and joins all the cluster nodes to this domain. The domain join is accomplished using Samba tools. Here are some of the prerequisities for the domain join to succeed.
  1. The domain name should resolve through DNS 
    * The IP address of the domain controllers should be set in the DNS settings for the VNET where the cluster is being deployed
    * If the VNET is peered with the VNET of AAD DS, then it has be done manually.
    * If you are using DNS forwarders, the domain name must resolve correctly within the vnet
  2. Security policies (NSGs) should not block the domain join
    * Between the subnet where the cluster is deployed and the domain controller, multiple ports are used for domain join
    
### What happens when the DNS settings are incorrect?
Cluster creation will fail with a DomainNotFound error message.

### How to debug this further?
* Deploy a windows VM in the same subnet, domain join the machine using a username and password (this can be done through the control panel UI)
OR
* Deploy a ubuntu VM in the same subnet and domain join the machine
  * SSH into the machine
  * sudo su
  * Run the [script](https://github.com/hdinsight/hdinsight.github.io/blob/master/EnterpriseSecurityPackage/Scripts/domainjoin.sh) with username and password
  * The script will ping, create the required configuration files and then domain. If it succeeeds, your DNS settings are good.
