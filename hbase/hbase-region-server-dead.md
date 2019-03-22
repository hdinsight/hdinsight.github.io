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

If you are running HBase cluster v3.4 you might have been hit by a potential bug caused by upgrade of jdk to version 1.7.0_151. The symptom we see is region server process starts occupying close to 200% CPU (to verify this run the top command; if there is a process occupying close to 200% CPU get its pid and confirm it is region server process by running ps -aux &#124; grep <pid>) and the region server is essentially rendered dead, causing alerts to fire on HBase Master process and cluster to not function at full capacity.

The mitigation/solution for the problem at a high level (details below) is to:

1)	Install jdk 1.8 on ALL nodes of the cluster as below:

Run the script action https://raw.githubusercontent.com/Azure/hbase-utils/master/scripts/upgradetojdk18allnodes.sh 

Be sure to select the option to run on all nodes. Alternatively, you can log in to every individual node and run the command
                                                                                                                                         
"sudo add-apt-repository ppa:openjdk-r/ppa -y && sudo apt-get -y update && sudo apt-get install -y openjdk-8-jdk"

2)	Go to Ambari UI - https://&#60;clusterdnsname&#62;.azurehdinsight.net; go to HBase->Configs->Advanced->Advanced hbase-env configs and change the variable JAVA_HOME as below:

"export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64."

Save the config change.

3)	[Optional but recommended] Flush all tables on cluster. https://blogs.msdn.microsoft.com/azuredatalake/2016/09/19/hdinsight-hbase-how-to-improve-hbase-cluster-restart-time-by-flushing-tables/

4)	From Ambari UI again, restart all HBase services that need restart.

5)	Depending on the data on cluster, it might take a few minutes to upto an hour for the cluster to reach stable state. The way you confirm the cluster reaches stable state is by either checking HMaster UI (all region servers should be active) from Ambari (refresh) or from headnode run hbase shell and then run status command

To verify that your upgrade was successful check that the relevant HBase processes are started using the appropriate java version - for instance for regionserver check as 

"ps -aux &#124; grep regionserver, and verify the version like '''/usr/lib/jvm/java-8-openjdk-amd64/bin/java"


# Region Servers dead due to WAL splitting

We have seen incidents where the Region Server fails to start due to multiple Splitting WAL directories.

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


