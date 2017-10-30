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

If you are running HBase cluster v3.4 or v 3.5 you might have been hit by a potential bug caused by upgrade of jdk to version 1.7.0_151. The symptom we see is region server process starts occupying close to 200% CPU (to verify this run the top command; if there is a process occupying close to 200% CPU get its pid and confirm it is region server process by running ps -aux | grep <pid>) and the region server is essentially rendered dead, causing alerts to fire on HBase Master process and cluster to not function at full capacity.

The mitigation/solution for the problem at a high level (details below) is to:

1)	Install jdk 1.8 on ALL nodes of the cluster as below:
                                                                                                                                         
"sudo add-apt-repository ppa:openjdk-r/ppa -y && sudo apt-get -y update && sudo apt-get install -y openjdk-8-jdk"

2)	Go to Ambari UI - https://<clusterdnsname>.azurehdinsight.net; go to HBase->Configs->Advanced->Advanced hbase-env configs and change the variable JAVA_HOME as below:

"export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64."

Save the config change.

3)	[Optional but recommended] Flush all tables on cluster. https://blogs.msdn.microsoft.com/azuredatalake/2016/09/19/hdinsight-hbase-how-to-improve-hbase-cluster-restart-time-by-flushing-tables/

4)	From Ambari UI again, restart all HBase services that need restart.

5)	Depending on the data on cluster, it might take a few minutes to upto an hour for the cluster to reach stable state. The way you confirm the cluster reaches stable state is by either checking HMaster UI (all region servers should be active) from Ambari (refresh) or from headnode run hbase shell and then run status command

To verify that your upgrade was successful check that the relevant HBase processes are started using the appropriate java version - for instance for regionserver check as 

"ps -aux | grep regionserver, and verify the version like '''/usr/lib/jvm/java-8-openjdk-amd64/bin/java"





