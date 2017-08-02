---
title: Cluster creation failed due to 'not sufficient fault domains in region | Microsoft Docs
description: Use the Kafka FAQ for answers to common questions on Kafka on Azure HDInsight platform.
keywords: Azure HDInsight, Kafka, FAQ, troubleshooting guide, common problems
services: Azure HDInsight
documentationcenter: na
author: apadma
manager: ''
editor: ''

ms.assetid: 8db5c415-26ef-4647-bda3-9fce99c8d805
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 08/02/2017
ms.author: apadma
---

## Cluster creation failed due to 'not sufficient fault domains in region

A fault domain is a logical grouping of underlying hardware in an Azure data center. Each fault domain shares a common power source and network switch. The virtual machines and managed disks that implement the nodes within an HDInsight cluster are distributed across these fault domains. This architecture limits the potential impact of physical hardware failures.

Each Azure region has a specific number of fault domains. For a list of domains and the number of fault domains they contain, refer to documentation on  [Availability Sets](https://review.docs.microsoft.com/en-us/azure/virtual-machines/linux/regions-and-availability#availability-sets
).

In HDInsight, we require Kafka clusters to be provisioned in a region with at least 3 Fault domains.

If the region you wish to create the cluster does not have sufficient fault domains, please reach out to product team to allow provisioning of the cluster even if there are not 3 fault domains.