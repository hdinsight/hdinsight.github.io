
# My Cluster Creation Fails Due To 

## Issue
You have set up an UDR for your cluster, and you encounter a failure with:
* ErrorCode "FailedToConnectWithClusterErrorCode"
* ErrorDescription: "Unable to connect to cluster management endpoint. Please retry later."

## Resolution
Search for "/providers/Microsoft.Network/routeTables" in the JSON file to find the UDR. There can be more than one route defined for the subscription in that region, So check the Subnets section to validate if that route is applied to the subnet where cluster is deployed. Once you find the routetable which is applicable for the subnet then Inspect the "routes" section in it. If there is not route specified for the cluster then you can ignore.

An example scenario is that it has a default nextHop for a "VirtualAppliance" and its IP address (read about virtual appliance here). In this case, you should make sure that there are routes for IP addresses for the region where customer deployed the cluster mentioned [here](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network#hdinsight-nsg). There should be a route defined for each required IP Address documented in the aforementioned article with a "NextHopType" of "Internet". An example is provided below:
<pre>
  {
   "name": "HDInsightManagement_138.91.141.162",
   "resourceGuid": "8d8544d3-ac50-4ff8-8e51-5509e9422d20",
   "etag": "W/"66acbe76-286b-42d5-be10-fbb750356219"",
   "groupName": "RandomGroup",
   "subscriptionId": "SubId",
   "fullName": [
      "HDINSIGHT-Management-IPS",
      "HDInsightManagement_138.91.141.162"
     ],
    "lastOperationId": "5442d19c-5720-4276-89c8-d20ac52eaf92",
    "lastOperationType": "Microsoft.WindowsAzure.Networking.Nrp.Frontend.Operations.Csm.PutRouteOperation",
    "lastModifiedTime": "2017-03-31T18:26:47.5597549Z",
    "createdTime": "0001-01-01T00:00:00",
    "properties": {
       "provisioningState": "Succeeded",
       "addressPrefix": "138.91.141.162/32",
       "nextHopType": "Internet",
       "internalRouteName": "HDInsightManagement_138.91.141.162"
    }
  }
</pre>


