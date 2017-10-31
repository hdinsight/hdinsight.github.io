# My Cluster Creation Fails with the ErrorCode InvalidNetworkSecurityGroupSecurityRules

If you see this error code (with the description *"The security rules in the Network Security Group <nsg> configured with subnet <subnet> does not allow required inbound and/or outbound connectivity."*), it indicates a problem with the inbound [network security group](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-nsg) rules configured for your cluster.

## Resolution
Go to the Azure Portal and identify the NSG that is associated with the subnet where the cluster is being deployed. In the "Inbound security rules" section, make sure the rules allow inbound access to port 443 for the IP addresses mentioned [here](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network#hdinsight-ip).
