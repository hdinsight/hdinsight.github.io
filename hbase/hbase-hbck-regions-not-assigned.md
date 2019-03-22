---
title: HBase Hbck command reporting holes in the chain of regions | Microsoft Docs
description: Troubleshooting the cause of holes in the chain of regions.
services: hdinsight
documentationcenter: ''
author: nitinver
manager: ashitg

ms.service: hdinsight
ms.custom: hdinsightactive
ms.devlang: na
ms.topic: article
ms.tgt_pltfrm: na
ms.workload: big-data
ms.date: 04/11/2017
ms.author: nitinver
---

### Running 'hbase hbck' command reports multiple unassigned regions.

#### Error:

Passed in file status is for something other than a regular file

#### Detailed Description:

Regions are offline. Running hbck returned that there were holes in the region chain. 
When I looked at HBase Master UI, I saw there was a region in transition or WAL splitting for a long time. 
Looking at the logs I saw there was a WAL split failing all the time and the error was that 

~~~~
       2017-05-12 11:55:01,993 ERROR [RS_LOG_REPLAY_OPS-10.0.0.14:16020-1] executor.EventHandler: Caught throwable while processing event RS_LOG_REPLAY
       java.lang.IllegalArgumentException: passed in file status is for something other than a regular file.
       at com.google.common.base.Preconditions.checkArgument(Preconditions.java:92)
       at org.apache.hadoop.hbase.wal.WALSplitter.splitLogFile(WALSplitter.java:271)
       at org.apache.hadoop.hbase.wal.WALSplitter.splitLogFile(WALSplitter.java:235)
       at org.apache.hadoop.hbase.regionserver.SplitLogWorker$1.exec(SplitLogWorker.java:104)
       at org.apache.hadoop.hbase.regionserver.handler.WALSplitterHandler.process(WALSplitterHandler.java:72)
       at org.apache.hadoop.hbase.executor.EventHandler.run(EventHandler.java:128)
       at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
       at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
       at java.lang.Thread.run(Thread.java:745)
~~~~

#### Probable Cause:

Checking the /hbase/WALs/xxxx-splitting, I noticed there was one folder having the WAL file, the others only contained a meta file which means the WAL split had already been finished. I did "hdfs dfs -ls <that WAL file path>", I saw the file length was 0. That was why Regionserver thought it was not a WAL file. I guessed something happened during the creation of the WAL file

#### Resolution Steps:

The mitigation was deleting this file and restart the active HMaster so that HBase skipped this WAL file splitting and those offline regions became online again.

- - -

#### If no errors found in logs

It is a common issue to see 'multiple regions being unassigned or holes in the chain of regions' when the HBase user runs 'hbase hbck' command.

The user would see the count of regions being un-balanced across all the region servers from HBase Master UI. After that, user can run 'hbase hbck' command and shall notice holes in the region chain.

The user should first fix the assignments, because holes may be due to those offline regions. 

Follow the steps below to bring the unassigned regions back to normal state:

1. Login to HDInsight HBase cluster using SSH.

2. Run 'hbase zkcli' command to connect with zookeeper shell.

3. Run 'rmr /hbase/regions-in-transition' or 'rmr /hbase-unsecure/regions-in-transition' command.

4. Exit from 'hbase zkcli' shell by using 'exit' command.

5. Open Ambari UI and restart Active HBase Master service from Ambari.

6. Run 'hbase hbck' command again (without any further options).

Check the output of command in step 6 and ensure that all regions are being assigned.



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
