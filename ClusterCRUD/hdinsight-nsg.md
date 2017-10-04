# My Cluster Creation Fails Due To Invalid Network Security Group (NSG) Rules

## Issue
You have set up an NSG for your cluster, and you encounter a failure with:
* ErrorCode "InvalidNetworkSecurityGroupSecurityRules"
* ErrorDescription: "The security rules in the Network Security Group '/subscriptions/<subscription-id>/resourceGroups/TheWire-Staging/providers/Microsoft.Network/networkSecurityGroups/thewirestaging-nsg' configured with subnet '/subscriptions/6f7de897-d5ae-4ecd-ad16-c5863d3c097c/resourceGroups/TheWire-Staging/providers/Microsoft.Network/virtualNetworks/thewirestaging-vnet/subnets/subnet1' does not allow required inbound and/or outbound connectivity. For more information please visit http://go.microsoft.com/fwlink/?linkid=785236 or contact support"

## Resolution
Search for "/providers/Microsoft.Network/networkSecurityGroups/<ClusterNsgName>" in this (#!! which?) file. In the "securityRules" section, make sure the rules allow inbound access to port 443 for the IP addresses mentioned [here](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network#hdinsight-ip) AND allow outbound access to internet without limitation. Note that here lower "priority" number means higher priority. Also, in the "subnets" section you can confirm if this NSG is applied to the cluster subnet.

To successfully install NSG outbound should be allowed for all (#!! IPs?). Azure Storage and SQL do not have fixed IP Address, so we need to allow outbound connections (to all IPs?) to allow accessing these services.


