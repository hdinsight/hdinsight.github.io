---
title: Common issues during cluster upgrade | Microsoft Docs
description: Diagnosing and fixing issue during cluster upgrade
services: hdinsight
documentationcenter: ''
author: duoxu
manager: ashitg

ms.service: hdinsight
ms.custom: hdinsightactive
ms.devlang: na
ms.topic: article
ms.tgt_pltfrm: na
ms.workload: big-data
ms.date: 11/10/2017
ms.author: duoxu
---

# HDP upgrade causes no data in Phoenix views

We have a customer upgrading their cluster from 3.4 to 3.5 (HDP 2.4 to HDP 2.5), there is one view contains no data after new cluster was created.
 
i see the view in sqlline... i see no data in the view in sqlline though

```
0: jdbc:phoenix:zk1-profil> select count(*) from table1_view;
+-----------+
| COUNT(1)  |
+-----------+
| 1         |
+-----------+
```
however in the table that the view is backed by... 
```
0: jdbc:phoenix:zk1-profil> select count(*) from table1;
+-----------+
| COUNT(1)  |
+-----------+
| 1823616   |
+-----------+
```
HBCK returned fine, so there are no offline regions.


The root cause is actually that index table for views (all indexes for view are stored in a single physical HBase table) is truncated during upgrade and it’s expected that user will recreate them.

In phoenix-core/src/main/java/org/apache/phoenix/util/UpgradeUtil.java, there are comments that

```
 // Disable the view index and truncate the underlying hbase table. 
 // Users would need to rebuild the view indexes. 
```
Users should drop and recreate all indexes after upgrade.

