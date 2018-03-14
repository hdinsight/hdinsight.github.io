# Ambari account password expiration extension

Traditionally, HDInsight base Ubuntu Images did not explicitly set the password expiration of Hadoop accounts. Recent Linux Kernel enforced password expiration after 70 days. However, Hadoop account should not expire. Only user added accounts should have an expiration.


We have corrected the base image and also patched most of customer clusters. We could not patch some clusters where the NSG rule prevented us from connecting with the cluster.

## Mitigation
* To mitigate the issue manually you need to:

  * First reset the admin password in the Azure portal to get headnode access.

  * Then run the following commands in a shell windows on all nodes:
    * Update passwords of internal accounts

			sudo chage -M 99999 yarn
			
			sudo chage -M 99999 oozie
			
			sudo chage -M 99999 hive
			
			sudo chage -M 99999 ambari-qa
			
			sudo chage -M 99999 zookeeper
			
			sudo chage -M 99999 tez
			
			sudo chage -M 99999 sqoop
			
			sudo chage -M 99999 hcat
			
			sudo chage -M 99999 ams
			
			sudo chage -M 99999 hbase
			
			sudo chage -M 99999 storm
			
			sudo chage -M 99999 kafka
			
			sudo chage -M 99999 spark
			
			sudo chage -M 99999 falcon
			
			sudo chage -M 99999 ranger
			
			sudo chage -M 99999 kms
			
			sudo echo "patching ambari user expiry policy completed." | logger


* Alternatively, you can also run the script via script action located [here](https://hdiconfigactions.blob.core.windows.net/userexpirationpolicyfix/userexpirationpolicyfix.sh)

  Please make sure that HDInsight management IP’s are able to access your clusters.

  [Required IPs](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network#hdinsight-ip-1)

  [Required ports](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-extend-hadoop-virtual-network#hdinsight-ports)
