# My Cluster Creation Fails Due To an Issue With Custom DNS Setup

## Issue
You have set up a custom DNS for your cluster, and you encounter a failure with:
* ErrorCode "FailedToConnectWithClusterErrorCode"
* ErrorDescription: "Unable to connect to cluster management endpoint. Please retry later."

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

If 168.63.129.16 is not the first server in this list, then there are 2 options to fix this issue:

1. Add this as the first custom DNS for the vNet using the steps described in [here](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network#example-dns).

1. Deploy a DNS server VM for the vNet. (TODO: Create and insert link to instructions for this.)

If 168.63.129.16 is already in the list, then please create a support case with HDInsight, and we will investigate your issue. Before creating the case, follow the steps in [Validate HostName resolution for a cluster with Custom DNS](#validate-hostname-resolution-for-a-cluster-with-custom-dns). Including the result of these commands in your support case will help us investigate and resolve the issue quicker.

### Validate HostName resolution for a cluster

Ssh into the cluster head node, and run the below commands. Please include the results of these commands in your support case:

`Hostname -f`

`nslookup <headnode_fqdn>` (e.g.nslookup hn1-hditest.5h6lujo4xvoe1kprq3azvzmwsd.hx.internal.cloudapp.net)

`dig @168.63.129.16 <headnode_fqdn>` (e.g. dig @168.63.129.16 hn0-hditest.5h6lujo4xvoe1kprq3azvzmwsd.hx.internal.cloudapp.net). This uses the **Azure Recursive Resolver (IPAddress: 168.63.129.16)** for name resolution. Note the output of this command - it should 0 or 1.

