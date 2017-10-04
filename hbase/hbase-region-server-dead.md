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

If you are running HBase cluster v3.4 or v 3.5 you might have been hit by a potential bug caused by upgrade of jdk to version 1.7.0_151. The symptom we see is region server process starts occupying close to 200% CPU and the region server is essentially rendered dead, causing alerts to fire on HBase Master process and cluster to not function at full capacity.
The mitigation/solution for the problem at a high level (details below) is to:
1.	Install jdk 1.8 on all nodes of the cluster
2.	For HBase services, set JAVA_HOME to point to the new location
3.	Restart HBase services

Detailed steps:
1.	Install jdk 1.8 on all nodes of the cluster:
a.	Obtain JIT Access on ACIS, HDInsight as a platform service administrator.
b.	Use the ACIS option to run adhoc Iaas script, script location is at https://gkanadeazcopywestusid2.blob.core.windows.net/scriptactions/upgradetojdk18allnodes.sh
c.	Verify that the script executed successfully on all nodes. The way to do this is to run the Kusto query – Csyslog | where ClusterDnsName = <clusterdnsname> | where PreciseTimeStamp > ago(1h) | where Msg contains “java-8-openjdk-amd64". You need to ensure that there is at least one entry corresponding to every node on the cluster. (Get Ambari access to cluster to verify the names of all nodes if needed. Also it is ok if some nodes have more than one entry, but if any node has entry missing it indicates that the script did not execute successfully on that node yet, wait for upto 15 minutes and retry the query)
2.	Go to Ambari UI of cluster; go to HBase->Configs->Advanced->Advanced hbase-env configs and change the variable JAVA_HOME as export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64. Save the config change.
3.	[Optional but recommended] Flush all tables on cluster. https://blogs.msdn.microsoft.com/azuredatalake/2016/09/19/hdinsight-hbase-how-to-improve-hbase-cluster-restart-time-by-flushing-tables/
4.	From Ambari UI again, restart all HBase services that need restart.
5.	Depending on the data on cluster, it might take a few minutes to upto an hour for the cluster to reach stable state. The way you confirm the cluster reaches stable state is by either checking HMaster UI (all region servers should be active) from Ambari (refresh) or from headnode run hbase shell and then run status command





