# I can't add nodes to my cluster

## **Recommended steps**
 To resolve common issues, try one or more of the following steps.
 
 1. [Check to see if there are any cores available](data-blade:Microsoft_Azure_HDInsight.CoresUsageBreakdownBlade) in the cluster's location.
 2. Using the [Scale cluster feature](data-blade:Microsoft_Azure_HDInsight.ScaleClusterBlade), calculate the number of additional cores needed for the cluster. This is based on the total number of cores in the new worker nodes.
 3. Take a look at the number of available cores in other locations. Consider recreating your cluster in a different location with enough available cores.
 4. If you'd like to increase the core quota for a specific location, please file a support ticket for an HDInsight core quota increase.

## **Recommended documents**
[Manage clusters in the portal - Scale clusters](https://azure.microsoft.com/documentation/articles/hdinsight-administer-use-portal-linux/#scale-clusters)<br>
