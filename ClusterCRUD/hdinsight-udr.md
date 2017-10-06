
# My Cluster Creation Fails Due To an Issue with User-defined Routes (UDR)

## Issue
You have set up an UDR for your cluster, and you encounter a failure with:
* ErrorCode "InvalidNetworkConfigurationErrorCode"
* ErrorDescription: "Virtual Network configuration is not compatible with HDInsight Requirement. Error: 'Failed to connect to Azure Storage Account; Failed to connect to Azure SQL; HostName Resolution failed', Please follow https://go.microsoft.com/fwlink/?linkid=853974 to fix it."

## Resolution
Go to the Azure Portal and identify the route table that is associated with the subnet where the cluster is being deployed. Once you find the routetable for the subnet, inspect the "routes" section in it.

If there is no route specified for the cluster then it is probably not a proble with the UDR configuration. It could be related to an NSG configuration issue. Refer here to troubleshoot NSG issues: https://github.com/ansi12/hdinsight.github.io/edit/patch-1/ClusterCRUD/hdinsight-nsg.md.

If there are routes defined, make sure that there are routes for IP addresses for the region where the cluster was deployed, and the "NextHopType" for each route is "Internet". Refer to [this document](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network#hdinsight-ip) for details. There should be a route defined for each required IP Address documented in the aforementioned article.
