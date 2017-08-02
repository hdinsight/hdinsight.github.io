---
title: TSG: Are Kafka logs saved or persisted across Kafka cluster lifecycles? | Microsoft Docs
description: Use the Kafka FAQ for answers to common questions on Kafka on Azure HDInsight platform.
keywords: Azure HDInsight, Kafka, FAQ, troubleshooting guide, common problems
services: Azure HDInsight
documentationcenter: na
author: apadma
manager: ''
editor: ''

ms.assetid: 8b3d30ce-03fb-40ef-af3a-bc513550b740
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 08/02/2017
ms.author: apadma
---

## Are Kafka logs saved or persisted across Kafka cluster lifecycles?

Kafka logs are not saved or persisted across cluster lifecycles. This is irrespective of whether the customer is using managed disks. Customers can investigate using Kafka mirror maker for this purpose, or they can write their own solution. 

References: 
- [Kafka Mirror Maker](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-apache-kafka-mirroring)
- [Kafka Mirror Maker Best Practices](https://community.hortonworks.com/articles/79891/kafka-mirror-maker-best-practices.html)
