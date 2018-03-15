---
title: Why does Ambari Tez View load very slowly? | Microsoft Docs
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
ms.author: NithinM
---

### Why does Ambari Tez View load very slowly?
#### Issue
Accessing Yarn ATS APIs may sometimes have poor performance on clusters created before Oct 2017 when the cluster has large number of Hive jobs run on it.

#### Symptoms
- Ambari Tez View may load very slowly or may not load at all.
- When loading Ambari Tez View, you may see processes on Headnodes becoming unresponsive.


#### Resolution Steps
1.	yarn.timeline-service.ttl-ms is the config in YARN which decides how much data the ATS should retain. Reduce this to a shorter duration, say 1 day (86400000 ms).
2.	yarn.timeline-service.leveldb-timeline-store.ttl-interval-ms is the config in YARN which decides how often the cleanup should run. Change this to a very low value (say 10 min – 600000 ms) if you need immediate mitigations. Note that the first cleanup will run after this period of time when the ATS service is restarted.
3.	Restart ApplicationTimelineServer through Ambari->YARN.
4.	Reset yarn.timeline-service.leveldb-timeline-store.ttl-interval-ms to a considerable period if you reduced it to a value less than few hours to ensure that cleanup does not run very often.


#### Long Term Solution
1.	This is an issue that has been fixed in Oct 2017. Recreating your cluster will make it not run into this problem again.
