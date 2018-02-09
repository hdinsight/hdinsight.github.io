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
```insert into table1 partition(a,b) select a,b,c from table2;```

the query plan starts a bunch of reducers but the data from the each partition goes to a single reducer. This causes the query to be as slow as the time taken by the largest parition's reducer.

#### Troubleshoot: 
Open [beeline](https://docs.microsoft.com/en-us/azure/hdinsight/hadoop/apache-hadoop-use-hive-beeline) and verify the value of 
```set hive.optimize.sort.dynamic.partition```

The value of this variable is meant to be set to true/false based on the nature of the data.

If the partitions in the input table is less(say less than 10), and so is the the number of output partitions, and the variable is set to ```true```, this causes data to be globally sorted and written using a single reducer per partition. Even if the number of reducers available is larger, a few reducers may be lagging behind due to data skew and the max parallelism cannot be attained. When changed to ```false```, more than one reducer may handle a single partition and multiple smaller files will be written out, resulting in faster insert. This might affect further queries though because of the presence of smaller files. 

A value of ```true``` makes sense when the number of partitions is larger and data is not skewed. In such cases the result of the map phase will be written out such that each partition will be handled by a single reducer resulting in better subsequent query performance.


#### Resolution: 
1. Try to repartition the data to normalize into multiple partitions.
2. If #1 is not possible, set the value of the config to false in beeline session and try the query again.
```set hive.optimize.sort.dynamic.partition=false```.
Setting the value to false at a cluster level is not recommended. The value of ```true``` is optimal and set the parameter as necessary based on nature of data and query. 