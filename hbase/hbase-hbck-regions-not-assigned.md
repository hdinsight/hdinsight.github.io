---
title: HBase Hbck command reporting holes in the chain of regions | Microsoft Docs
description: Troubleshooting the cause of holes in the chain of regions.
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
ms.date: 04/11/2017
ms.author: nitinver
---

# Running 'hbase hbck' command reports multiple unassigned regions.

It is a common issue to see 'multiple regions being unassigned or holes in the chain of regions' when the HBase user runs 'hbase hbck' command.

The user would see the count of regions being un-balanced across all the region servers from HBase Master UI. After that, user can run 'hbase hbck' command and shall notice holes in the region chain.

The user should first fix the assignments, because holes may be due to those offline regions. 

Follow the steps below to bring the unassigned regions back to normal state:

1. Login to HDInsight HBase cluster using SSH.

2. Run 'hbase zkcli' command to connect with zookeeper shell.

3. Run 'rmr /hbase/regions-in-transition' or 'rmr /hbase-unsecure/regions-in-transition' command.

4. Exit from 'hbase zkcli' shell by using 'exit' command.

5. Open Ambari UI and restart Active HBase Master service from Ambari.

6. Run 'hbase hbck' command again (without any further options).

Check the output of command in step 6 and ensure that all regions are being assigned.
