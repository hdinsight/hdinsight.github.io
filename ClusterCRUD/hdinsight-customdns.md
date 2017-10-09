# My Cluster Creation Fails Due To an Issue With Custom DNS Setup

## Issue: InvalidNetworkConfigurationErrorCode
You have set up a custom DNS for your cluster, and you encounter a failure with:
* ErrorCode: InvalidNetworkConfigurationErrorCode
* ErrorDescription: Virtual Network configuration is not compatible with HDInsight Requirement. Error: 'Failed to connect to Azure Storage Account; Failed to connect to Azure SQL; HostName Resolution failed', Please follow https://go.microsoft.com/fwlink/?linkid=853974 to fix it.

## Resolution
Follow the steps below to validate that your custom DNS is set up properly.

### Validate that 168.63.129.16 is in the custom DNS chain
DNS servers within a virtual network can forward DNS queries to Azure's recursive resolvers to resolve hostnames within that virtual network (see [Name Resolution in Virtual Networks](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances#name-resolution-using-your-own-dns-server) for details). Access to Azure's recursive resolvers is provided via the virtual IP 168.63.129.16.

ssh into the cluster head node, and run the below command:

`sshuser@hostname:~$ cat /etc/resolv.conf | grep nameserver*`

You should see something like this:

`nameserver 168.63.129.16`

`nameserver 10.21.34.43`

`nameserver 10.21.34.44`

Based on the result - choose one of the following steps to follow:

### 1. If 168.63.129.16 is not in this list:

  Then are 2 options to fix this issue:

  1. Add this as the first custom DNS for the vNet using the steps described in [here](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network#example-dns). [Note: These steps are applicable only if your custom DNS server runs on Linux.]

  2. Deploy a DNS server VM for the vNet. This involves the following steps:
    * Create a VM in the vNet which will be configured as DNS forwarder (it can be a Linux or windows VM).  
    * Configure DNS forwarding rules on this VM (forward all iDNS name resolution requests to 168.63.129.16, and the rest to your DNS server)  
    * Add the IP Address of this VM as first DNS entry for Virtual Network DNS configuration.

### 2. If 168.63.129.16 is already in the list:

  In this case, please create a support case with HDInsight, and we will investigate your issue. Please include the result of the below commands in your support case. This will help us investigate and resolve the issue quicker.

  Ssh into the cluster head node, and run the below commands.

  1. `hostname -f`

  2. `nslookup <headnode_fqdn>` (e.g.nslookup hn1-hditest.5h6lujo4xvoe1kprq3azvzmwsd.hx.internal.cloudapp.net)

  3. `dig @168.63.129.16 <headnode_fqdn>` (e.g. dig @168.63.129.16 hn0-hditest.5h6lujo4xvoe1kprq3azvzmwsd.hx.internal.cloudapp.net)

