---
title: Why does the Hive Zeppelin Interpreter give a Zookeeper error? | Microsoft Docs
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

### Why does the Hive Zeppelin Interpreter give a Zookeeper error?

#### Issue
The Zeppelin Hive JDBC Interpreter is pointing to the wrong URL

#### Symptoms
On a Hive LLAP cluster, the Zeppelin interpreter gives the following error message when attempting to execute a query:

```
java.sql.SQLException: org.apache.hive.jdbc.ZooKeeperHiveClientException: Unable to read HiveServer2 configs from ZooKeeper
```

#### Resolution Steps

1. Navigate to the Hive component summary and copy the "Hive JDBC Url" to the clipboard.

2. Navigate to https://clustername.azurehdinsight.net/zeppelin/#/interpreter

3. Edit the JDBC settings: update the _hive.url_ value to the Hive JDBC URL copied in step 1

4. Save, then retry the query