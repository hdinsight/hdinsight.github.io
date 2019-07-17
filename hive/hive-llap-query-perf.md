---
title: Why are my LLAP queries running slow? | Microsoft Docs
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
ms.author: msft-tacox
---

### Poor Performance in Hive LLAP queries
#### Issue
The default cluster configurations are not sufficiently tuned for your workload


#### Symptoms
Queries in Hive LLAP are executing slower than expected. This can happen due to a variety of reasons.

#### Resolution Steps
##### Option 1
LLAP is optimized for queries that involve joins and aggregates. Queries like the following don't perform well in an Interactive Hive cluster:

```
select * from table where column = "columnvalue"
```

To improve point query performance in Hive LLAP, set the following configurations:

```
hive.llap.io.enabled=false; (disable LLAP IO)
hive.optimize.index.filter=false; (disable ORC row index)
hive.exec.orc.split.strategy=BI; (to avoid recombining splits)
```

##### Option 2
You can also increase usage the LLAP cache to improve performance with the following configuration change:
```
hive.fetch.task.conversion=none
```
