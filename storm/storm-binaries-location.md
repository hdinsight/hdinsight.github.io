### Where are the Storm Binaries on HDInsight cluster?

#### Issue:
 Know location of binaries for Storm services on HDInsight cluster

#### Resolution Steps:

Storm binaries for current HDP Stack can be found at:
 /usr/hdp/current/storm-client

This location is the same for Headnodes as well as worker nodes.
 
There may be multiple HDP version specific binaries located under /usr/hdp
(example: /usr/hdp/2.5.0.1233/storm)

But the /usr/hdp/current/storm-client is sym-linked to the latest version that is run on the cluster.

#### Further Reading:
 [Connect to HDInsight Cluster using SSH](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-linux-use-ssh-unix)
 [Storm](http://storm.apache.org/)
