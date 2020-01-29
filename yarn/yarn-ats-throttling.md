---
title: YARN App Timeline Server gets throttled by Informatica Blaze Engine | Microsoft Docs
description: YARN App Timeline Server gets throttled by Informatica Blaze Engine, causing Ambari and YARN unhealthy.
keywords: Azure HDInsight, Yarn, FAQ, troubleshooting guide, ATS
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
ms.date: 10/09/2019
ms.author: jiesh

---

### YARN App Timeline Server gets throttled by Informatica Blaze Engine

#### Symptoms:

1. Warning or critical alert "Ambari Server Performance" is fired in Ambari.
2. Ambari is slow or behaving erratically.
3. Scaling up and / or adding edge nodes is failing.
4. Ambari and YARN keep logging off.

#### Debug: 

1. Check if jobs are submitted through Informatica Blaze engine.
2. Check if Informatica Blaze engine is shutdown abruptly.
3. Confirm App Timeline Server (ATS) is throttled: check if there are lots of "Cannot get a connection, pool error Timeout waiting for idle object" warnings in /var/log/hadoop-yarn/yarn/ yarn-yarn-timelineserver-*.log on both headnodes.

#### Cause:

This is caused by a bug in Informatica Blaze engine that continuously polls the ATS database for ATS entities. No matter what the database SKU is, it will reach 100% DTU utilization affecting all other operations.

#### Solution:

Informatica has a hotfix (EBF-14471) for this issue. Customers who are facing this problem may work with Informatica support team for more specifics on the bug and the fix in Blaze.
