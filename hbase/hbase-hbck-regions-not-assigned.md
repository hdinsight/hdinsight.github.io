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
