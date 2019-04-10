---
title: Azure HDInsight Solutions | Ambari | Hive check is failing 
description: Learn how to resolve <scenario>
services: hdinsight
author: <author_github_account>
ms.author: <author_ms_alias>
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: <date>
---

# Azure HDInsight Solutions | Ambari | Hive View check is failing 

## Scenario: Browsing to Hive View using ambari portal  failes with connectivity between zookeeper and HiveServer2

## Issue : 

## Troubleshooting:
From hive server logs ```/var/log/hive``` identified following error to confirm HiveServer2 lost connectivity with Zookeeper

```
`ERROR [Curator-Framework-0]: curator.ConnectionState (ConnectionState.java:checkTimeouts(200)) - Connection timed out for connection string (zk0-cluster.cloud.wbmi.com:2181,zk1-cluster.cloud.wbmi.com:2181,zk2-cluster.cloud.wbmi.com:2181) and timeout (15000) / elapsed (21852)` 
```

1. Check if Zookeeper Service is UP and healthy.

2. Check hiveserver2 logs for any entries metioned below to confirm  connectivity lost

```
/var/log/hive has error
`ERROR [Curator-Framework-0]: curator.ConnectionState (ConnectionState.java:checkTimeouts(200)) - Connection timed out for connection string (zk0-cluster.cloud.wbmi.com:2181,zk1-cluster.cloud.wbmi.com:2181,zk2-cluster.cloud.wbmi.com:2181) and timeout (15000) / elapsed (21852)` 
```

3. Check if Zookeeper has a entry of znode for hiveserver2
	a. to Connect to ZooKeeper node from headnode
	

```
cd /usr/hdp/2.6.2.25-1/zookeeper/bin
  ./zkCli.sh -server zk1-wbwdhs
```

	b. Issue the commands below to check for entry for HiveServer2 in Zookeeper

```
[zk: zk0-cluster(CONNECTED) 0] ls /hiveserver2-hive2
[serverUri=hn0-cluster.ruqj3gnyxpbe5j1nua22md5inc.cx.internal.cloudapp.net:10001;version=2.1.0.2.6.3.2-14;sequence=0000000001]
[zk: zk0-cluster(CONNECTED) 1]
```

4. If ERROR log is seen as mentioned in Step 2 and Zookeeper does not have Entry for Hive Server 2 as shown in Step 3. 

5. To reestablish Connectivity, Restarted Zookeeper nodes and HiveServer2.

6. Check for Entry in ZooKeeper node for HiveServer2. If the Entry Exists.

7. Hive View should be up and running.
