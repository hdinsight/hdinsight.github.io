---
title: How do I access Storm UI on HDInsight cluster? | Microsoft Docs
description: Use the Storm FAQ for answers to common questions on Storm on Azure HDInsight platform.
keywords: Azure HDInsight, Storm, FAQ, troubleshooting guide, common problems, Storm UI
services: Azure HDInsight
documentationcenter: na
author: raviperi
manager: ''
editor: ''

ms.assetid: B7DF87E1-E27F-4725-818E-013B45DBBD98
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 05/14/2017
ms.author: raviperi
---

### How do I access Storm UI on HDInsight cluster?

#### Issue:
There are two ways to access Storm UI from a browser:
##### Ambari UI
1) Navigate to Ambari Dashboard
2) Select Storm from List of services in the left
3) Select Storm UI option from Quick Links drop-down menu

##### Direct Link
Storm UI is accessible from URL:

https://\<ClusterDnsName\>/stormui

example: https://stormcluster.azurehdinsight.net/stormui

