# My Cluster Creation Fails with InvalidNetworkConfigurationErrorCode

If your ErrorDescription says *"Virtual Network configuration is not compatible with HDInsight Requirement"*, it usually points to a problem with the [virtual network configuration](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network) for your cluster. Based on the rest of the error description, please follow the below sections to resolve your problem

##  ErrorDescription contains "HostName Resolution failed"

Validate that 168.63.129.16 is in the custom DNS chain
DNS servers within a virtual network can forward DNS queries to Azure's recursive resolvers to resolve hostnames within that virtual network (see [Name Resolution in Virtual Networks](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances#name-resolution-using-your-own-dns-server) for details). Access to Azure's recursive resolvers is provided via the virtual IP 168.63.129.16.

ssh into the cluster head node, and run the below command:

`sshuser@hostname:~$ cat /etc/resolv.conf | grep nameserver*`

You should see something like this:

`nameserver 168.63.129.16`

`nameserver 10.21.34.43`

`nameserver 10.21.34.44`

Based on the result - choose one of the following steps to follow:

### If 168.63.129.16 is not in this list:

Deploy a DNS server VM for the vNet. This involves the following steps:
    * Create a VM in the vNet which will be configured as DNS forwarder (it can be a Linux or windows VM).  
    * Configure DNS forwarding rules on this VM (forward all iDNS name resolution requests to 168.63.129.16, and the rest to your DNS server)  
    * Add the IP Address of this VM as first DNS entry for Virtual Network DNS configuration.

Refer [here](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network#example-dns) for an example of this setup. [Note: These steps are applicable only if your custom DNS server runs on Linux.]

### If 168.63.129.16 is already in the list:

  In this case, please create a support case with HDInsight, and we will investigate your issue. Please include the result of the below commands in your support case. This will help us investigate and resolve the issue quicker.

  Ssh into the cluster head node, and run the below commands.

  1. `hostname -f`

  2. `nslookup <headnode_fqdn>` (e.g.nslookup hn1-hditest.5h6lujo4xvoe1kprq3azvzmwsd.hx.internal.cloudapp.net)

  3. `dig @168.63.129.16 <headnode_fqdn>` (e.g. dig @168.63.129.16 hn0-hditest.5h6lujo4xvoe1kprq3azvzmwsd.hx.internal.cloudapp.net)
  

## ErrorDescription contains "Failed to connect to Azure Storage Account" or "Failed to connect to Azure SQL"

Azure Storage and SQL do not have fixed IP Addresses, so we need to allow outbound connections to all IPs to allow accessing these services.

The steps to fix this depends on whether you have set up a Network Security Group (NSG) or User-Defined Rules (UDR).
### If your cluster uses a Network Security Group (NSG)
Go to the Azure Portal and identify the NSG that is associated with the subnet where the cluster is being deployed. In the "Outbound security rules" section, allow outbound access to internet without limitation. Note that here, a lower "priority" number means higher priority. Also, in the "subnets" section, confirm if this NSG is applied to the cluster subnet.

If there your issue is still not resolved, and you have set up User Defined Rules (UDR) - it could be an issue with the UDR configuration. Please refer [here](hdinsight-udr.md) to troubleshoot UDR issues. Otherwise, please raise a support case, and we will investigate the issue.

### If your cluster uses a User-defined Routes (UDR)
Go to the Azure Portal and identify the route table that is associated with the subnet where the cluster is being deployed. Once you find the routetable for the subnet, inspect the "routes" section in it.

If there are routes defined, make sure that there are routes for IP addresses for the region where the cluster was deployed, and the "NextHopType" for each route is "Internet". Refer to [this document](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network#hdinsight-ip) for details. There should be a route defined for each required IP Address documented in the aforementioned article.

If neither of these resolve the problem, then please create a support ticket, and we will investigate your issue.
