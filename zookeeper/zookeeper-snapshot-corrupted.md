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

### Issue:

Zookeeper server is unhealthy, 

### Cause:
Zookeeper server will not remove old snapshot files from its data directory, instead, it is a periodic task to be performed by users to maintain the heathiness of zookeeper. When the snapshot files are corrupted, zookeeper server will fail to form a quarum, which causes zookeeper related services unhealthy.

### Resolution Steps:
1. Backup snapshots in /hadoop/zookeeper/version-2 and /hadoop/hdinsight-zookeepe/version-2.
2. Clean up snapshots in /hadoop/zookeeper/version-2 and /hadoop/hdinsight-zookeepe/version-2.
3. Restart all zookeeper servers.
