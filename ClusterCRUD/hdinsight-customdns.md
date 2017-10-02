# My Cluster Creation Fails Due To an Issue With Custom DNS Setup

If your cluster creation fails with an error ---, follow these steps to validate if the custom DNS server is setup correctly.

## Validate Outbound connection is allowed for the vNet
Run `telnet www.bing.com 443`. If it is successfully connected then outbound connection is allowed.

## Validate if 168.63.129.16 is in the custom DNS chain
DNS servers within a virtual network can forward DNS queries to Azure's recursive resolvers to resolve hostnames within that virtual network. Access to Azure's recursive resolvers is provided via the virtual IP 168.63.129.16. Run the below command to see if 168.63.129.16 the first dns server in the list of the command output:

`sshuser@hostname:~$ cat /etc/resolv.conf | grep nameserver*`

Command Output will be something like this:

`nameserver 168.63.129.16`

`nameserver 10.21.34.43`

`nameserver 10.21.34.44`

If 168.63.129.16 is not in the list then add this as the first custom dns for the vNet. There is also another way to fix this which is recommended way and need to deploy a DNS server VM for the vNet you can see section [Azure_Custom_DNS_Configuration_Documentation](#azure-custom-dns-configuration-documentation) for more details.

## Azure Custom DNS Configuration Documentation
Make sure you have followed the [Azure Documentation](https://azure.microsoft.com/en-us/documentation/articles/virtual-networks-name-resolution-for-vms-and-role-instances/#name-resolution-using-your-own-dns-server) to configure Custom Dns. We only support DNS forwarding to Azure recursive resolver for resolution of host names within the vNet, and do not support other options mentioned in this documentation.

## Validate HostName resolution for a cluster with Custom DNS
Run `Hostname -f` and check if it is able to return the host FQDN.
Run `nslookup <headnode_fqdn>` (e.g.nslookup hn1-hditest.5h6lujo4xvoe1kprq3azvzmwsd.hx.internal.cloudapp.net) and check if it is able to resolve the IpAddress for the given fqdn.

If above command are successful then it means that custom DNS is not an issue and it is able to resolve the hostname. If any of the steps above failed and you want to validate the name resolution using **Azure Recursive Resolver(IPAddress: 168.63.129.16)** then follow [Validate HostName resolution using Azure Recursive Resolver](#validate-hostname-resolution-using-azure-recursive-resolver)

## Validate HostName resolution using Azure Recursive Resolver
Run `dig @168.63.129.16 <headnode_fqdn>` (e.g. dig @168.63.129.16 hn0-hditest.5h6lujo4xvoe1kprq3azvzmwsd.hx.internal.cloudapp.net). This will try to resolve hostname using **Azure recursive resolver(168.63.129.16)**. After running the command look for Answer in output, If you see the Answer count is 1 as highlighted in below image which means it is able to resolve the hostname. In below image you can see that count for Answer is 1 and Answer Section contains private IP address of the node. If it says 0 which means it is not able to resolve. If you remove @168.63.129.16 from the command and run it then it will use the vNet configured dns to resolve the hostname.
[[File:DigOutput.png]]
