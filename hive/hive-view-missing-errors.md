---
title: Why does my query fail in Hive View without any details? | Microsoft Docs
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

### Why does my query fail in Hive View without any details?
#### Issue
Sometimes the error message of a query failure may be too large to display on the Hive View main page

#### Symptoms
The Hive View query error message will look something like this, without further information:

`"Failed to execute query. <a href="#/messages/1">(details)</a>"`

#### Solution
Check the Notifications tab on the Top right corner of the Hive_view to see the complete Stacktrace and Error Message.