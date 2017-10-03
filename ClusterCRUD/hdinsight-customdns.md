# My Cluster Creation Fails Due To an Issue With Custom DNS Setup

##Issue: You have set up a custom DNS for your cluster, and you encounter the ErrorCode "FailedToConnectWithClusterErrorCode" (ErrorDescription: "Unable to connect to cluster management endpoint. Please retry later.").

##Resolution: Follow the steps below to validate that your custom DNS is set up properly.

### Validate that 168.63.129.16 is in the custom DNS chain
DNS servers within a virtual network can forward DNS queries to Azure's recursive resolvers to resolve hostnames within that virtual network. Access to Azure's recursive resolvers is provided via the virtual IP 168.63.129.16.

ssh into the cluster head node, and run the below command:

`sshuser@hostname:~$ cat /etc/resolv.conf | grep nameserver*`

You should see something like this:

`nameserver 168.63.129.16`

`nameserver 10.21.34.43`

`nameserver 10.21.34.44`

If 168.63.129.16 is not the first server in this list, then there are 2 options to fix this issue:

1. Add this as the first custom dns for the vNet using the steps described in [Azure HDInsight Virtual Network documentation](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network#example-dns).

2. Deploy a DNS server VM for the vNet. (Create and insert link to instructions here.)

If 168.63.129.16 is already in the list, then please create a support case with HDInsight, and we will investigate your issue. Before creating the case, follow the steps in [Validate HostName resolution for a cluster with Custom DNS](#validate-hostname-resolution-for-a-cluster-with-custom-dns). Including the result of these commands in your support case will help us investigate the issue quicker.

### Validate HostName resolution for a cluster with Custom DNS

ssh into the cluster head node, and run the below command:
Run `Hostname -f` and check if it is able to return the host's FQDN.
Run `nslookup <headnode_fqdn>` (e.g.nslookup hn1-hditest.5h6lujo4xvoe1kprq3azvzmwsd.hx.internal.cloudapp.net) and check if it is able to resolve the IpAddress for the given fqdn.

If above commands are successful, then the custom DNS is probably not an issue and it is able to resolve the hostname. If any of the steps above failed and you want to validate the name resolution using **Azure Recursive Resolver(IPAddress: 168.63.129.16)** then follow [Validate HostName resolution using Azure Recursive Resolver](#validate-hostname-resolution-using-azure-recursive-resolver)

### Validate HostName resolution using Azure Recursive Resolver
Run `dig @168.63.129.16 <headnode_fqdn>` (e.g. dig @168.63.129.16 hn0-hditest.5h6lujo4xvoe1kprq3azvzmwsd.hx.internal.cloudapp.net). This will try to resolve hostname using **Azure recursive resolver(168.63.129.16)**. After running the command look for Answer in output, If you see the Answer count is 1 as highlighted in below image which means it is able to resolve the hostname. In below image you can see that count for Answer is 1 and Answer Section contains private IP address of the node. If it says 0 which means it is not able to resolve. If you remove @168.63.129.16 from the command and run it then it will use the vNet configured dns to resolve the hostname.
[[File:DigOutput.png]]

