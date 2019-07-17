---
title: Why is the Hive View inaccessible due to Zookeeper Issues? | Microsoft Docs
description: Use the Hive FAQ for answers to common questions on Hive on Azure HDInsight platform.
keywords: Azure HDInsight, ambari, Tez, FAQ, troubleshooting guide, 
services: Azure HDInsight
documentationcenter: na
author: 
manager: ''
editor: ''


ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 01/17/2018
ms.author: msft-tacox
---

### Why is the Hive View inaccessible due to Zookeeper Issues?
#### Issue
It is possible that Hive may fail to establish a connection to Zookeeper, which prevents the Hive View from launching.

#### Symptoms
The Hive View is inaccessible, and the logs in /var/log/hive show an error similar to the following:

`ERROR [Curator-Framework-0]: curator.ConnectionState (ConnectionState.java:checkTimeouts(200)) - Connection timed out for connection string (zk0-cluster.cloud.wbmi.com:2181,zk1-cluster.cloud.wbmi.com:2181,zk2-cluster.cloud.wbmi.com:2181) and timeout (15000) / elapsed (21852)` 


### Resolution Steps
1. Check that the Zookeeper service is healthy
2. Check if the Zookeeper service has a ZNode entry for Hive Server2. The value will be missing or incorrect.	

```
  /usr/hdp/2.6.2.25-1/zookeeper/bin/zkCli.sh -server zk1-wbwdhs
  [zk: zk0-cluster(CONNECTED) 0] ls /hiveserver2-hive2
```

3. To re-establish connectiviy, reboot the Zookeeper nodes, and reboot HiveServer2
