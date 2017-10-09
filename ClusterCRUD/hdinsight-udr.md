
# My Cluster Creation Fails Due To an Issue with User-defined Routes (UDR)

## Issue: InvalidNetworkConfigurationErrorCode
You have set up UDR for your cluster, and you encounter a failure with:
* ErrorCode: InvalidNetworkConfigurationErrorCode
* ErrorDescription: Virtual Network configuration is not compatible with HDInsight Requirement. Error: 'Failed to connect to Azure Storage Account; Failed to connect to Azure SQL; HostName Resolution failed', Please follow https://go.microsoft.com/fwlink/?linkid=853974 to fix it.

## Resolution
Go to the Azure Portal and identify the route table that is associated with the subnet where the cluster is being deployed. Once you find the routetable for the subnet, inspect the "routes" section in it.

If there are routes defined, make sure that there are routes for IP addresses for the region where the cluster was deployed, and the "NextHopType" for each route is "Internet". Refer to [this document](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network#hdinsight-ip) for details. There should be a route defined for each required IP Address documented in the aforementioned article.

If there is no route specified for the cluster, then it is probably not a problem with the UDR configuration. If you have also set up a Network Security Group (NSG), you might have a problem with the NSG configuration. Refer [here](https://hdinsight.github.io/ClusterCRUD/hdinsight-nsg.html) to troubleshoot NSG issues.
