---
title: Why do some joins in Hive give an Out of Memory error? | Microsoft Docs
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

### Why do some joins in Hive give an Out of Memory error?
#### Issue
The default behavior for Hive joins is to load the entire contents of a table into memory so that a join can be performed without having to perform a Map/Reduce step. If the Hive table is too large to fit into memory, the query can fail.

#### Symptoms
When running joins in hive of sufficient size, the following error is encountered:

```
Caused by: java.lang.OutOfMemoryError: GC overhead limit exceeded error.
```

#### Resolution Steps
Prevent Hive from loading tables into memory on joins (instead performing a Map/Reduce step) by setting the following Hive configuration value:
```
hive.auto.convert.join=false
```
