---
title: How can I transfer Storm eventhub spout checkpoint information from one topology to another? | Microsoft Docs
description: Use the Storm FAQ for answers to common questions on Storm on Azure HDInsight platform.
keywords: Azure HDInsight, Storm, FAQ, troubleshooting guide, common problems, EventHubs spout, checkpoint, zookeeper
services: Azure HDInsight
documentationcenter: na
author: raviperi
manager: ''
editor: ''

ms.assetid: 74E51183-3EF4-4C67-AA60-6E12FAC999B5
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 05/14/2017
ms.author: raviperi
---

### How can I transfer Storm eventhub spout checkpoint information from one topology to another?

#### Issue:
When developing topologies that read from event hubs using HDInsight's Storm eventhub spout jar, 
how can one deploy a topology with the same name on a new cluster,
but retain the checkpoint data committed to zookeeeper in the old cluster?

##### Where is checkpoint data stored
Checkpoint data for offsets is stored by EventHub spout into Zookeeper under two root paths:

Non transactional spout checkpoints are stored under: /eventhubspout

Transaction spout checkpoint data is stored under: /transactional

##### How to Restore
The scripts and libraries to export data out of zookeeper and import it back under a new name can be found at:
https://github.com/hdinsight/hdinsight-storm-examples/tree/master/tools/zkdatatool-1.0

The lib folder has Jar files that contain the implementation for the import/export operation.
The bash folder has an example script on how to export data from Zookeeper server on old cluster, and import it back into zookeeper server on new cluster.

The [stormmeta.sh](https://github.com/hdinsight/hdinsight-storm-examples/blob/master/tools/zkdatatool-1.0/bash/stormmeta.sh) script needs to be run from the Zookeeper nodes to import/export data.
The script needs to be updated to correct the HDP version string in it.
(HDInsight is working on making these scripts generic, so they can run from any node in the cluster without need for modifications by end user).

The export command will write the metadata to a HDFS Path (BLOB or ADLS store) at the specified location.

##### Examples

###### Export Offset metadata:
1) SSH into the zookeeper cluster on old cluster from which checkpoint offset needs to be exported.
2) Run below command (after updating the hdp version string) to export zookeeper offset data into /stormmetadta/zkdata HDFS Path.
   
   java -cp ./*:/etc/hadoop/conf/*:/usr/hdp/2.5.1.0-56/hadoop/*:/usr/hdp/2.5.1.0-56/hadoop/lib/*:/usr/hdp/2.5.1.0-56/hadoop-hdfs/*:/usr/hdp/2.5.1.0-56/hadoop-hdfs/lib/*:/etc/failover-controller/conf/*:/etc/hadoop/* com.microsoft.storm.zkdatatool.ZkdataImporter export /eventhubspout /stormmetadata/zkdata

###### Import Offset metadata
1) SSH into the zookeeper cluster on old cluster from which checkpoint offset needs to be exported.
2) Run below command (after updating the hdp version string) to import zookeeper offset data from HDFS path /stormmetadata/zkdata into Zookeeper server on target cluster).

   java -cp ./*:/etc/hadoop/conf/*:/usr/hdp/2.5.1.0-56/hadoop/*:/usr/hdp/2.5.1.0-56/hadoop/lib/*:/usr/hdp/2.5.1.0-56/hadoop-hdfs/*:/usr/hdp/2.5.1.0-56/hadoop-hdfs/lib/*:/etc/failover-controller/conf/*:/etc/hadoop/* com.microsoft.storm.zkdatatool.ZkdataImporter import /eventhubspout /home/sshadmin/zkdata
   
###### Delete Offset metadata so topologies can start processing data from (either beginning or timestamp of user choice)
1) SSH into the zookeeper cluster on old cluster from which checkpoint offset needs to be exported.
2) Run below command (after updating the hdp version string) to delete all zookeeper offset data for current cluster

   java -cp ./*:/etc/hadoop/conf/*:/usr/hdp/2.5.1.0-56/hadoop/*:/usr/hdp/2.5.1.0-56/hadoop/lib/*:/usr/hdp/2.5.1.0-56/hadoop-hdfs/*:/usr/hdp/2.5.1.0-56/hadoop-hdfs/lib/*:/etc/failover-controller/conf/*:/etc/hadoop/* com.microsoft.storm.zkdatatool.ZkdataImporter delete /eventhubspout
