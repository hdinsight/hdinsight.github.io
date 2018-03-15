---
title: How is Ambari used in HDInsight? | Microsoft Docs
description: Use the Ambari FAQ for answers to common questions on Ambari on Azure HDInsight platform.
keywords: Ambari, Azure HDInsight, FAQ, troubleshooting guide, common problems, accessing folder
services: Azure HDInsight
documentationcenter: na
author: shzhao
manager: ''
editor: ''

ms.assetid: 
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 03/14/2018
ms.author: shzhao
---

### How is Ambari used in HDInsight?

HDInsight uses Ambari for cluster deployment and management. Ambari agent runs on every node (headnode, workernode, zookeeper and edgenode if exists). Ambari server runs only on headnode (hn0 or hn1), and at any point in time, there should only be 1 Ambari server running. This is controlled by HDInsight failover controller. When one of the headnode is down for reboot or maintenance, the other headnode will become active and Ambari server on the second headnode will be started.

All cluster configuration should be done through the Ambari UI, any local change will be overwritten when the node is restarted.

#### Failover controller services

The HDInsight failover controller is also responsible for updating the IP address of headnodehost, which points to the current active head node. All Ambari agents are configured to report its state and heartbeat to headnodehost. The failover controller is a set of services running on every node in the cluster, if they are not running, the headnode failover may not work correctly and you'll end up with HTTP 502 when trying to access Ambari server.

To check which headnode is active, one way is to ssh to one of the node in the cluster, then run "ping headnodehost" and compare the IP with that of the two headnodes.

If failover controller services are not running, headnode failover may not happen correctly which may end up not running Ambari server. To check if failover controller services are running:
~~~~
ps -ef | grep failover
~~~~

#### Logs

On the active headnode, you can check the Ambari server logs at:
~~~~
/var/log/ambari-server/ambari-server.log
/var/log/ambari-server/ambari-server-check-database.log
~~~~

On any node in the cluster, you can check the Ambari agent logs at:
~~~~
/var/log/ambari-agent/ambari-agent.log
~~~~

#### Service start sequences

This is the sequence of service start at boot time:
1) hdinsight-agent starts failover controller services
2) failover controller services start Ambari agent on every node and Ambari server on active headnode

#### Ambari Database
HDInsight creates SQL Azure DB under the hood to serve as the database for Ambari server. The default service tier is S0, please check what this means here:
https://docs.microsoft.com/en-us/azure/sql-database/sql-database-resource-limits

For any cluster with workernode count bigger than 16 when creating the cluster, we choose S2 as the database service tier, which handles load for a bigger cluster better. 

#### Takeaway points

Never manually start/stop ambari-server or ambari-agent services, unless you are trying to restart the service to workaround an issue. To force a failover, you can reboot the active headnode.

Never manually modify any configuration files on any cluster node, let Ambari UI do the job for you.


