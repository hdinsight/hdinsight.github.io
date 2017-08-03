---
title: TSG: Could not find leader nimbus from seed hosts [headnodehost] | Microsoft Docs
description: Use the Storm FAQ for answers to common questions on Storm on Azure HDInsight platform.
keywords: Azure HDInsight, Storm, FAQ, troubleshooting guide, log4j
services: Azure HDInsight
documentationcenter: na
author: raviperi
manager: ''
editor: ''

ms.assetid: d7c14702-948b-41db-bb45-7185fde247f1
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 08/02/2017
ms.author: apadma
---
## TSG: Could not find leader nimbus from seed hosts [headnodehost] on HDI 3.3 on Windows

### Issue:

HDI 3.3 for Windows initially was running a version of Storm which did not have HA support for Nimbus. To provide HA support, we deployed a custom component that copies topologies artifacts from the active nimbus to the other nimbus every 5 minutes. 
In very rare cases, where a nimbus node undergoes a reboot shortly after a new topology is submitted (and before the scheduled copy task could complete),both nimbus nodes may end up not having the topology code locally. 

### Solution:

1. Verify this is indeed the case by looking at the Nimbus logs. This can be found under the local storm folder ```C:\hdistorm\stormdist```. The symptoms will be as follows:
```
2017-07-29 17:40:52.302 b.s.zookeeper [INFO] headnode0.*****.a5.internal.chinacloudapp.cn gained leadership, checking if it has all the topology code locally.
2017-07-29 17:40:52.309 b.s.zookeeper [INFO] active-topology-ids [TOPOLOGY-NAME-1498805833,TOPOLOGY-2-NAME-1500962748] local-topology-ids [TOPOLOGY-3-NAME-1498553914,TOPOLOGY-4-NAME-1498614910] diff-topology [TOPOLOGY-3-NAME-1498805833,TOPOLOGY-NAME-4-1500962748]
2017-07-29 17:40:52.309 b.s.zookeeper [INFO] code for all active topologies not available locally, giving up leadership.
```
2. Verify that the Topology information if found in Zookeeper via the zookeeper command line tool.
```
[zk: localhost:2181(CONNECTED) 5] get /storm/storms
[TOPOLOGY-NAME-1498805833, TOPOLOGY-2-NAME-1500962748]
```
3. To mitigate this, copy the topology artifacts for the specific topology from the stormdist folder in one of the supervisor nodes to both nimbus nodes.

4. Once the copy is done, restart the Storm nimbus service. The issue should now be fixed as seen from Nimbus logs:
```
2017-08-01 02:10:26.040 b.s.zookeeper [INFO] headnode0.cmi-cdp-storm-cd-prd.a5.internal.chinacloudapp.cn gained leadership, checking if it has all the topology code locally.
2017-08-01 02:10:26.043 b.s.zookeeper [INFO] active-topology-ids [TOPOLOGY-NAME-1498805833,TOPOLOGY-NAME-1500962748] local-topology-ids [TOPOLOGY-NAME-1498805833,TOPOLOGY-NAME-1498553914,TOPOLOGY-NAME-6-1498614910,TOPOLOGY-NAME-1500962748] diff-topology []
2017-08-01 02:10:26.043 b.s.zookeeper [INFO] Accepting leadership, all active topology found localy.
```
