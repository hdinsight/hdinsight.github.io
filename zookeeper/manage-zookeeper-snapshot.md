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
# Azure HDInsight Solutions | Zookeeper |  Common Issues caused by ZooKeeper

## Issue:
Many services running on HDInsight clusters depend on ZooKeeper service. ZooKeeper being unhealthy could cause many problems, symptoms could include: both Resource Managers/Name Nodes are in standby mode, simple HDFS operations do not work, zkFailoverController is stopped and cannot be started, Yarn/Spark/Livy jobs fail due to ZooKeeper errors, cannot login ESP clusters with domain users.

```
19/06/19 08:27:08 ERROR ZooKeeperStateStore: Fatal Zookeeper error. Shutting down Livy server.
19/06/19 08:27:08 INFO LivyServer: Shutting down Livy server.
```

## Mitigation Steps:
1. Check Yarn/Spark/Livy/Credential Service logs to confirm if the failure is related to ZooKeeper errors, there may exist some "KeeperException" in the log.
2. Verify all 3 ZooKeeper servers are running fine:
   1) Check in Ambari -> Hosts if any of the ZooKeeper hosts is in heartbeat lost state. If a ZooKeeper host loses heartbeat, try to login this host and restart Ambari Agent with command "sudo service ambari-agent restart". Restart the host if cannot login. Then restart the service which has problems.
   2) If no ZooKeeper host heartbeat lost issue exists or after the issue is solved, next step is to check ZooKeeper server health: login any host of the cluster, run command "vi /etc/hosts" and get the ip addresses of the 3 ZooKeeper hosts. Then, run commands ```echo mntr | nc {zk_host_ip} 2181" and "echo mntr | nc {zk_host_ip} 2182``` for all 3 ZooKeeper hosts, if either of the commands returns nothing or "This ZooKeeper instance is not currently serving requests", ZooKeeper server is not healthy on that machine. Restart ZooKeeper server from Ambari and restart the service which has problems.
3. Check if ZooKeeper runs out of memory:
   1) Login each ZooKeeper host and check ZooKeeper heap usage with command “top | grep zookeep+”. By default, ZooKeeper heap size is 1024MB.
   2) On each ZooKeeper host, check ZooKeeper logs in directory /var/log/zookeeper, look for “java.lang.OutOfMemoryError: GC overhead limit exceeded” or “java.lang.OutOfMemoryError: Java heap space”.
   3) To mitigate this problem, in Ambari, go to ZooKeeper tab, click on “Configs” and search for “zk_server_heapsize”, the default value should be 1024MB. Increase this value, then restart all affected services from Ambari and the service which has problems.
4. Check if cleanup ZooKeeper snapshots and transaction logs can do the magic. In HDInsight clusters, by default, the most recent 30 snapshots and related transaction logs will be retained and older files are automatically purged every 24 hours. When the volume of snapshot and transaction log files is large or the files are corrupted, ZooKeeper server will fail to start, which causes ZooKeeper related services unhealthy. For more details, refer to https://zookeeper.apache.org/doc/r3.3.5/zookeeperAdmin.html#sc_strengthsAndLimitations
   1) Check the status of other ZooKeeper servers in the same quorum to make sure they are working fine with the command "echo stat | nc {zk_host_ip} 2181 (or 2182)".
   1) Login the problematic ZooKeeper host, backup snapshots and transaction logs in /hadoop/zookeeper/version-2 and /hadoop/hdinsight-zookeeper/version-2, then cleanup these files in the two directories.
   2) Restart the problematic ZooKeeper server in Ambari or the ZooKeeper host. Then restart the service which has problems.
5. Check if ZooKeeper is refusing incoming connections from a certain host:
   1) On each ZooKeeper host, check ZooKeeper logs in /var/log/zookeeper, look for “Too many connections from /{host_ip} - max is 60”.
   2) Login the host with the “host_ip”, run command “echo mntr | nc {zk_host_ip} 2181”. If no output from the command, run “netstat -nape | awk '{if ($5 == "{zk_host_ip}:2181") print $4, $9;}' | sort | uniq -c” to find which process is sending active connections to ZooKeeper. Then restart the service corresponding to that process in Ambari.
   3) Sometimes there may be many inactive connections to ZooKeeper from a host, restart this host in this case. 
