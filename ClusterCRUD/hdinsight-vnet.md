# My Cluster Creation Fails with InvalidNetworkConfigurationErrorCode

If you see this error code (with the description *"Virtual Network configuration is not compatible with HDInsight Requirement"*), it usually indicates a problem with the [virtual network configuration](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network) for your cluster. Based on the rest of the error description, follow the below sections to resolve your problem.

## 1. ErrorDescription contains "HostName Resolution failed"

This error points to a problem with custom DNS configuration. DNS servers within a virtual network can forward DNS queries to Azure's recursive resolvers to resolve hostnames within that virtual network (see [Name Resolution in Virtual Networks](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances) for details). Access to Azure's recursive resolvers is provided via the virtual IP 168.63.129.16. This IP is only accessible from the Azure VMs. So it will not work if you are using an OnPrem DNS server, or your DNS server is an Azure VM which is not part of the cluster's vNet.

### Troubleshooting steps

  1. Ssh into the a VM that is part of the cluster, and run the command `hostname -f`.
  This will return the host's fully qualified domain name (referred to as `<host_fqdn>` in the below instructions).

  2. Then, run the command `nslookup <host_fqdn>` (e.g.nslookup hn1-hditest.5h6lujo4xvoe1kprq3azvzmwsd.hx.internal.cloudapp.net).
  If this command resolves the name to an IP address, it means your DNS server is working correctly. In this case, please raise a support case with HDInsight, and we will investigate your issue. In your support case, please include the troubleshooting steps you executed. This will help us resolve the issue faster.
  
  3. If the above command does not return an IP address, then run `nslookup <host_fqdn> 168.63.129.16` (e.g.nslookup hn1-hditest.5h6lujo4xvoe1kprq3azvzmwsd.hx.internal.cloudapp.net 168.63.129.16).
  If this command is able to resolve the IP, it means that either your DNS server is not forwarding the query to Azure's DNS, or it is not a VM that is part of the same vNet as the cluster.

Follow below instructions to configure your [custom DNS server](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances#name-resolution-using-your-own-dns-server) correctly.

   1. If you do not have an Azure VM that can act as a custom DNS server in the cluster's vNet, then you need to add this first. Create a VM in the vNet which will be configured as DNS forwarder (it can be a Linux or windows VM).

   2. Once you have a VM deployed in your vNet, configure the DNS forwarding rules on this VM. Forward all iDNS name resolution requests to 168.63.129.16, and the rest to your DNS server. [Here](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network#example-dns) is an example of this setup for a custom DNS server runing on Linux.

   3. Add the IP Address of this VM as first DNS entry for the Virtual Network DNS configuration.

## 2. ErrorDescription contains "Failed to connect to Azure Storage Account" or "Failed to connect to Azure SQL"

Azure Storage and SQL do not have fixed IP Addresses, so we need to allow outbound connections to all IPs to allow accessing these services. The exact resolution steps depend on whether you have set up a Network Security Group (NSG) or User-Defined Rules (UDR). Refer to the section on [controlling network traffic with HDInsight with network security groups and user-defined routes](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network#hdinsight-ip) for details on these configurations.

### If your cluster uses a [Network Security Group (NSG)](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-nsg)
Go to the Azure Portal and identify the NSG that is associated with the subnet where the cluster is being deployed. In the "Outbound security rules" section, allow outbound access to internet without limitation (note that a smaller "priority" number here means higher priority). Also, in the "subnets" section, confirm if this NSG is applied to the cluster subnet.

### If your cluster uses a [User-defined Routes (UDR)](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview)
Go to the Azure Portal and identify the route table that is associated with the subnet where the cluster is being deployed. Once you find the routetable for the subnet, inspect the "routes" section in it.

If there are routes defined, make sure that there are routes for IP addresses for the region where the cluster was deployed, and the "NextHopType" for each route is "Internet". There should be a route defined for each required IP Address documented in the aforementioned article.

If neither of these steps resolve the problem, then please create a support ticket, and we will investigate your issue.
