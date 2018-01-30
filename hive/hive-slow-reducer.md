---
title: Why is my reducer slow? | Microsoft Docs
description: Use the Hive FAQ for answers to common questions on Hive on Azure HDInsight platform.
keywords: Azure HDInsight, Hive, FAQ, troubleshooting guide, export metastore, import metastore
services: Azure HDInsight
documentationcenter: na
author: jyotima
manager: ''
editor: ''

ms.assetid: 921f8ed0-7327-4f5a-8a83-44e4a24bdd75
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 01/29/2018
ms.author: jyotima

---

### Why is my reducer slow?

#### Issue:
I am running a select and insert on a large dataset. The data in the datset is skewed and most of the data resides in one partition.

When I run a simple query which looks like this:
```insert into table1 select a,b,c from table2;```

the query plan starts a bunch of reducers but the data from the heaviest partition goes to a single reducer, causing it to run for a long time.

#### Troubleshoot: 
Open beeline and verify the value of 
```set hive.optimize.sort.dynamic.partition```

If the value of the parameter is set to true, it means that dynamic partitioning column will be globally sorted. This way we can keep only one record writer open for each partition value in the reducer thereby reducing the memory pressure on reducers.

#### Resolution: 
1. Try to repartition the data to normalize into multiple partitions.
2. If #1 is not possible, set the value of the config to false in beeline session and try the query again.
```set hive.optimize.sort.dynamic.partition=false```.
Setting the value to false might cause Out of Memory errors. 
The effect of setting the value to false at a cluster level in a HDP cluster is still being investigated. In the meantime please use the setting only for affected slow queries. 
