---
title: Zookeeper FAQ for Azure HDInsight | Microsoft Docs
description: Use the Zookeeper FAQ for answers to common questions on Zookeeper on Azure HDInsight platform.
keywords: Azure HDInsight, Zookeeper, FAQ, troubleshooting guide, common problems
services: Azure HDInsight
documentationcenter: na
author: jiesh
manager: ''
editor: ''

ms.assetid:
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 07/17/2019
ms.author: jiesh
---
# Azure HDInsight Solutions | Zookeeper |  Zookeeper server fails to form a quorum

## Issue:
Zookeeper server is unhealthy, symptoms could include: both Resource Managers/Name Nodes are in standby mode, simple HDFS operations do not work, zkFailoverController is stopped and cannot be started, Yarn/Spark/Livy jobs fail due to Zookeeper errors.

```
19/06/19 08:27:08 ERROR ZooKeeperStateStore: Fatal Zookeeper error. Shutting down Livy server.
19/06/19 08:27:08 INFO LivyServer: Shutting down Livy server.
```

## Troubleshooting Steps:
1. Check Yarn/Spark/Livy logs to find out if the failure is related to Zookeeper errors.
2. Run commands ```echo mntr | nc {zk_host_ip} 2181" and "echo mntr | nc {zk_host_ip} 2182``` for all zookeeper hosts, if either of the commands returns nothing or "This ZooKeeper instance is not currently serving requests", Zookeeper is not healthy on that machine.
3. Restart Zookeeper server does not solve the problem.
4. Check Zookeeper data directory /hadoop/zookeeper/version-2 and /hadoop/hdinsight-zookeepe/version-2 to find out if the snapshots file size is large.

## Cause:
Zookeeper server will not remove old snapshot files from its data directory, instead, it is a periodic task to be performed by users to maintain the healthiness of Zookeeper. When the volume of snapshot files is large or snapshot files are corrupted, Zookeeper server will fail to form a quorum, which causes zookeeper related services unhealthy. For more details, refer to https://zookeeper.apache.org/doc/r3.3.5/zookeeperAdmin.html#sc_strengthsAndLimitations

## Resolution Steps:
1. Backup snapshots in /hadoop/zookeeper/version-2 and /hadoop/hdinsight-zookeepe/version-2.
2. Clean up snapshots in /hadoop/zookeeper/version-2 and /hadoop/hdinsight-zookeepe/version-2.
3. Restart all zookeeper servers from Ambari UI.

