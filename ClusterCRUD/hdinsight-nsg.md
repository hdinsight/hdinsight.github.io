# My Cluster Creation Fails Due To an Issue with Network Security Group (NSG)

## Issue 1: InvalidNetworkSecurityGroupSecurityRules
You have set up an NSG for your cluster, and you encounter a failure with:
* ErrorCode: InvalidNetworkSecurityGroupSecurityRules
* ErrorDescription: The security rules in the Network Security Group <nsg> configured with subnet <subnet> does not allow required inbound and/or outbound connectivity. For more information please visit http://go.microsoft.com/fwlink/?linkid=785236 or contact support.

## Resolution
Go to the Azure Portal and identify the NSG that is associated with the subnet where the cluster is being deployed. In the "Inbound security rules" section, make sure the rules allow inbound access to port 443 for the IP addresses mentioned [here](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network#hdinsight-ip).

## Issue 2: InvalidNetworkConfigurationErrorCode
You have set up an NSG for your cluster, and you encounter a failure with:
* ErrorCode: InvalidNetworkConfigurationErrorCode
* ErrorDescription: Virtual Network configuration is not compatible with HDInsight Requirement. Error: 'Failed to connect to Azure Storage Account; Failed to connect to Azure SQL; HostName Resolution failed', Please follow https://go.microsoft.com/fwlink/?linkid=853974 to fix it.

## Resolution
Azure Storage and SQL do not have fixed IP Addresses, so we need to allow outbound connections to all IPs to allow accessing these services. To do this, go to the Azure Portal and identify the NSG that is associated with the subnet where the cluster is being deployed. In the "Outbound security rules" section, allow outbound access to internet without limitation. Note that here, a lower "priority" number means higher priority. Also, in the "subnets" section, confirm if this NSG is applied to the cluster subnet.

If there your issue is still not resolved, and you have set up User Defined Rules (UDR) - it could be an issue with the UDR configuration. Please refer [here](hdinsight-udr.md) to troubleshoot UDR issues. Otherwise, please raise a support case, and we will investigate the issue.


