---
title: HBase hbck timing out during fixing region assignments | Microsoft Docs
description: Troubleshooting the timeout of hbck command for fixing region assignments.
services: hdinsight
documentationcenter: ''
author: nitinver
manager: ashitg

ms.service: hdinsight
ms.custom: hdinsightactive
ms.devlang: na
ms.topic: article
ms.tgt_pltfrm: na
ms.workload: big-data
ms.date: 04/10/2017
ms.author: nitinver
---

# How to fix timeout issue with 'hbase hbck' command when fixing region assignments

The potential cause here could be several regions under "in transition" state for a long time. Those regions can be seen as offline from HBase Master UI. Due to high number of regions that are attempting to transition, HBase Master could timeout and will be unable to bring those regions back to online state.

Below are the steps to fix the hbck timeout problem:

1. Login to HDInsight HBase cluster using SSH.

2. Run 'hbase zkcli' command to connect with zookeeper shell.

3. Run 'rmr /hbase/regions-in-transition' or 'rmr /hbase-unsecure/regions-in-transition' command.

4. Exit from 'hbase zkcli' shell by using 'exit' command.

5. Open Ambari UI and restart Active HBase Master service from Ambari.

6. Run 'hbase hbck -fixAssignments' command again and it should not timeout any further.