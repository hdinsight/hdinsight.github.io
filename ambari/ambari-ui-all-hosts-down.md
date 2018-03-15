---
title: Ambari UI shows all hosts and services are down | Microsoft Docs
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

### Ambari UI shows all hosts and services are down

#### Issue
Customer can access Ambari UI but the UI shows almost all services are down, all hosts showing heartbeat lost.

#### Root cause
In most scenarios, this is an issue with Ambari server not running on the active headnode. Check which headnode is the active headnode and make sure your ambari-server runs on the right one. Don't manually start ambari-server, let failover controller service be responsible for starting ambari-server on the right headnode. Reboot the active headnode to force a failover. Please refer to another article "How is Ambari used in HDInsight?" for more info.

Networking issues can also cause this problem. From each cluster node, see if you can ping headnodehost. There is a rare situation where no cluster node can connect to headnodehost:
~~~~
$>telnet headnodehost 8440
... No route to host
~~~~

#### Mitigation and fix
Usually rebooting the active headnode will mitigate this issue. If not please contact HDInsight support team.