---
title: Not able to connect to Hive? | Microsoft Docs
description: Resolve the not able to connect to hive issue with the TSG.
keywords: Azure HDInsight, ambari, Hive, scale down, FAQ, troubleshooting guide
services: Azure HDInsight
documentationcenter: na
author: Marshall
manager: Shravan
editor: Marshall


ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 07/17/2019
ms.author: zhaya
---

#### Issue
Unable to connect through beeline. Unable to connect through hive view.

#### Investigation Steps
1. First log into Ambari UI. Check if severice `HIVESERVER2 INTERACTIVE` is up. 
2. If it is not "running" please check is it because the cluster is in `safemode`.
    ```
    $ hdfs dfsadmin -D "fs.default.name=hdfs://mycluster/" -safemode get
    ```
   If it is showing "ON" we know the safemode is causing this trouble.

There could be different reasons why the cluster is in safemode. Most commom reason is a scale down event.

#### Mitigation
1. Forcefully bring the cluster out from safemode.
```
$ hdfs dfsadmin -D "fs.default.name=hdfs://mycluster/" -safemode leave
```
2. Check again if the cluster is out from safemode now.
```
$ hdfs dfsadmin -D "fs.default.name=hdfs://mycluster/" -safemode get
```
3. Once cluster is out from safemode, go to Ambari and check the services in “Hive”, make sure Hiveserver2Interactive is running.
If not, start the service.
4. Now you should be able to use hive view on Ambari.

