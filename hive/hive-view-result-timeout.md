---
title: Why do some queries submitted via the Hive View fail with a timeout? | Microsoft Docs
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

### Why do some queries submitted via the Hive View fail with a timeout?
#### Issue
The Hive View default timeout value may not be suitable for the query you are running. The specified time period is too short for the Hive View to fetch the query result.

#### Symptoms
When running certain queries from the Hive view, the following error may be encountered:
    
```
result fetch timed out
java.util.concurrent.TimeoutException: deadline passed
```

#### Resolution Steps
1. Increase the Ambari Hive View timeouts by setting the following properties in "/etc/ambari-server/conf/ambari.properties"

```
views.ambari.request.read.timeout.millis=300000
views.request.read.timeout.millis=300000
views.ambari.hive<HIVE_VIEW_INSTANCE_NAME>.result.fetch.timeout=300000
```

The value of HIVE_VIEW_INSTANCE_NAME is available at the end of the Hive View URL.


