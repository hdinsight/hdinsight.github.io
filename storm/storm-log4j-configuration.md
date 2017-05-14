---
title: Where are Storm Log4J configuration files on HDInsight cluster? | Microsoft Docs
description: Use the Storm FAQ for answers to common questions on Storm on Azure HDInsight platform.
keywords: Azure HDInsight, Storm, FAQ, troubleshooting guide, log4j
services: Azure HDInsight
documentationcenter: na
author: raviperi
manager: ''
editor: ''

ms.assetid: 58D30B52-20FD-4A99-B67F-AE5EA1ECB51C
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 05/14/2017
ms.author: raviperi
---
### Where are Storm Log4J configuration files on HDInsight clusters?

#### Issue:

Identify Log4J configuration files for Storm services.

##### On HeadNodes:
Nimbus Log4J configuration is read from:
/usr/hdp/<HDPVersion>/storm/log4j2/cluster.xml

##### Worker Nodes
Supervisor's Log4J configuration is read from:
/usr/hdp/<HDPVersion>/storm/log4j2/cluster.xml

Worker Log4J configuration file is read from:
/usr/hdp/<HDPVersion>/storm/log4j2/worker.xml

Example:
/usr/hdp/2.6.0.2-76/storm/log4j2/cluster.xml
/usr/hdp/2.6.0.2-76/storm/log4j2/worker.xml
