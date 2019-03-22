---
title: One or more region servers dead | Microsoft Docs
description: Diagnosing and fixing dead region servers on hbase cluster
services: hdinsight
documentationcenter: ''
author: gkanade
manager: ashitg

ms.service: hdinsight
ms.custom: hdinsightactive
ms.devlang: na
ms.topic: article
ms.tgt_pltfrm: na
ms.workload: big-data
ms.date: 10/04/2017
ms.author: gkanade
---

# One or more dead region servers observed on hbase cluster

If you are running HBase cluster v3.4 you might have been hit by a potential bug caused by upgrade of jdk to version 1.7.0_151. The symptom we see is region server process starts occupying close to 200% CPU (to verify this run the top command; if there is a process occupying close to 200% CPU get its pid and confirm it is region server process by running ps -aux &#124; grep <pid>) and the region server is essentially rendered dead, causing alerts to fire on HBase Master process and cluster to not function at full capacity.

The mitigation/solution for the problem at a high level (details below) is to:

1)	Install jdk 1.8 on ALL nodes of the cluster as below:

Run the script action https://raw.githubusercontent.com/Azure/hbase-utils/master/scripts/upgradetojdk18allnodes.sh 

Be sure to select the option to run on all nodes. Alternatively, you can log in to every individual node and run the command
                                                                                                                                         
"sudo add-apt-repository ppa:openjdk-r/ppa -y && sudo apt-get -y update && sudo apt-get install -y openjdk-8-jdk"

2)	Go to Ambari UI - https://&#60;clusterdnsname&#62;.azurehdinsight.net; go to HBase->Configs->Advanced->Advanced hbase-env configs and change the variable JAVA_HOME as below:

"export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64."

Save the config change.

3)	[Optional but recommended] Flush all tables on cluster. https://blogs.msdn.microsoft.com/azuredatalake/2016/09/19/hdinsight-hbase-how-to-improve-hbase-cluster-restart-time-by-flushing-tables/

4)	From Ambari UI again, restart all HBase services that need restart.

5)	Depending on the data on cluster, it might take a few minutes to upto an hour for the cluster to reach stable state. The way you confirm the cluster reaches stable state is by either checking HMaster UI (all region servers should be active) from Ambari (refresh) or from headnode run hbase shell and then run status command

To verify that your upgrade was successful check that the relevant HBase processes are started using the appropriate java version - for instance for regionserver check as 

"ps -aux &#124; grep regionserver, and verify the version like '''/usr/lib/jvm/java-8-openjdk-amd64/bin/java"


# Region Servers dead due to WAL splitting

We have seen incidents where the Region Server fails to start due to multiple Splitting WAL directories.

Sample errors seen in var/log/hbase/region server log file:

2019-03-06 01:51:06,045 ERROR [RS_LOG_REPLAY_OPS-wn0-advana:16020-0] executor.EventHandler: Caught throwable while processing event RS_LOG_REPLAY
2019-03-06 01:51:13,129 ERROR [main] regionserver.HRegionServerCommandLine: Region server exiting
2019-03-06 01:58:04,847 ERROR [RS_LOG_REPLAY_OPS-wn0-advana:16020-0] executor.EventHandler: Caught throwable while processing event RS_LOG_REPLAY
2019-03-06 01:58:10,422 ERROR [main] regionserver.HRegionServerCommandLine: Region server exiting
org.apache.zookeeper.KeeperException$SessionExpiredException: KeeperErrorCode = Session expired for /hbase-unsecure/region-in-transition/c26a119d9014497f11f7945ee5765707
2019-03-06 01:58:04,847 ERROR [RS_LOG_REPLAY_OPS-wn0-advana:16020-0] executor.EventHandler: Caught throwable while processing event RS_LOG_REPLAY
2019-03-06 01:58:06,828 ERROR [RS_OPEN_REGION-wn0-advana:16020-2] handler.OpenRegionHandler: Failed open of region=SALES:SALES_TRANS_SKU,2016-04-16_14940401167_276107,1549148647976.3b69ed680668388f7c5723f491edc1c7., starting to roll back the global memstore size.
2019-03-06 01:58:08,672 ERROR [RS_CLOSE_META-wn0-advana:16020-0] regionserver.HRegion: Memstore size is 490232
2019-03-06 01:58:10,056 ERROR [RS_OPEN_REGION-wn0-advana:16020-8] regionserver.HRegion: Could not initialize all stores for the region=SALES:SALES_TRANS_SKU,2016-07-26_16381202590_129836,1549502700390.348bd64e19335f27a9f50f0b4bba5802.
2019-03-06 01:58:10,056 ERROR [RS_OPEN_REGION-wn0-advana:16020-1] regionserver.HRegion: Could not initialize all stores for the region=SALES:SALES_TRANS_SKU,2016-06-20_15881302257_70096,1549355619258.8eadc37b6743124b2b1c228fbc7fcd69.
org.apache.zookeeper.KeeperException$SessionExpiredException: KeeperErrorCode = Session expired for /hbase-unsecure/region-in-transition/d7107da93effb7d0476952020a45e93f
2019-03-06 01:58:10,424 ERROR [RS_OPEN_REGION-wn0-advana:16020-10] zookeeper.ZooKeeperWatcher: regionserver:16020-0x16884cf76828906, quorum=zk4-advana.svtv1pmtfjtunof0lhxfjaxxoe.cx.internal.cloudapp.net:2181,zk3-advana.svtv1pmtfjtunof0lhxfjaxxoe.cx.internal.cloudapp.net:2181,zk0-advana.svtv1pmtfjtunof0lhxfjaxxoe.cx.internal.cloudapp.net:2181, baseZNode=/hbase-unsecure Received unexpected KeeperException, re-throwing exception
org.apache.zookeeper.KeeperException$SessionExpiredException: KeeperErrorCode = Session expired for /hbase-unsecure/region-in-transition/c26a119d9014497f11f7945ee5765707
2019-03-06 01:58:10,425 ERROR [RS_OPEN_REGION-wn0-advana:16020-9] zookeeper.ZooKeeperWatcher: regionserver:16020-0x16884cf76828906, quorum=zk4-advana.svtv1pmtfjtunof0lhxfjaxxoe.cx.internal.cloudapp.net:2181,zk3-advana.svtv1pmtfjtunof0lhxfjaxxoe.cx.internal.cloudapp.net:2181,zk0-advana.svtv1pmtfjtunof0lhxfjaxxoe.cx.internal.cloudapp.net:2181, baseZNode=/hbase-unsecure Received unexpected KeeperException, re-throwing exception
org.apache.zookeeper.KeeperException$SessionExpiredException: KeeperErrorCode = Session expired for /hbase-unsecure/region-in-transition/d7107da93effb7d0476952020a45e93f
2019-03-06 01:58:10,427 ERROR [RS_OPEN_REGION-wn0-advana:16020-9] coordination.ZkOpenRegionCoordination: Failed transitioning node SALES:SALES_TRANS_SKU,2016-03-30_14396103271_227839,1549950999690.d7107da93effb7d0476952020a45e93f. from OPENING to FAILED_OPEN
org.apache.zookeeper.KeeperException$SessionExpiredException: KeeperErrorCode = Session expired for /hbase-unsecure/region-in-transition/d7107da93effb7d0476952020a45e93f
2019-03-06 01:58:10,427 ERROR [RS_OPEN_REGION-wn0-advana:16020-10] coordination.ZkOpenRegionCoordination: Failed transitioning node SALES:SALES_TRANS_SKU,2016-07-22_16395391578_222034,1549409261112.c26a119d9014497f11f7945ee5765707. from OPENING to FAILED_OPEN




Check the following things:

1) Get list of current wals
hadoop fs -ls -R /hbase/WALs/ > /tmp/wals.out

2) Inspect the wals.out to see if there are empty files
eg:
Empty files from the wals output:
Line 110: -rw-rwx---+  1 sshuser sshuser          0 2019-01-24 08:42 /hbase/WALs/wn1-advana.svtv1pmtfjtunof0lhxfjaxxoe.cx.internal.cloudapp.net,16020,1543299776294-splitting/wn1-advana.svtv1pmtfjtunof0lhxfjaxxoe.cx.internal.cloudapp.net,16020,1543299776294/wn1-advana.svtv1pmtfjtunof0lhxfjaxxoe.cx.internal.cloudapp.net%2C16020%2C1543299776294.default.1548319335505
Line 490: -rw-r-----+  1 sshuser sshuser          0 2019-03-08 04:21 /hbase/WALs/wn11-advana.svtv1pmtfjtunof0lhxfjaxxoe.cx.internal.cloudapp.net,16020,1552018852657-splitting/wn11-advana.svtv1pmtfjtunof0lhxfjaxxoe.cx.internal.cloudapp.net%2C16020%2C1552018852657..meta.1552018872799.meta
Line 788: -rw-r-----+  1 sshuser sshuser          0 2019-03-06 01:51 /hbase/WALs/wn2-advana.svtv1pmtfjtunof0lhxfjaxxoe.cx.internal.cloudapp.net,16020,1548362872417-splitting/wn2-advana.svtv1pmtfjtunof0lhxfjaxxoe.cx.internal.cloudapp.net,16020,1548362872417/wn2-advana.svtv1pmtfjtunof0lhxfjaxxoe.cx.internal.cloudapp.net%2C16020%2C1548362872417.default.1551837050362

3) If there are too many splitting directories (starting with *-splitting) the region server is probably failing because of these directories.

Mitigation: 
1) Stop Hbase from Ambari portal
2) Rerun hadoop fs -ls -R /hbase/WALs/ > /tmp/wals.out  to get fresh list of WALs
3) Move the *-splitting directories to a temporary folder and delete the *-splitting directories.
4) 
Run ‘hbase zkcli’ command to connect with zookeeper shell. 
Run ‘rmr /hbase-unsecure/splitWAL’ 
Restart hbase service


