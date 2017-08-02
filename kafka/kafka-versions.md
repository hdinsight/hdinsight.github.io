---
title: Which versions of Kafka is available on HDInsight? | Microsoft Docs
description: Use the Kafka FAQ for answers to common questions on Kafka on Azure HDInsight platform.
keywords: Azure HDInsight, Kafka, FAQ, troubleshooting guide, common problems
services: Azure HDInsight
documentationcenter: na
author: apadma
manager: ''
editor: ''

ms.assetid: b63a884e-187d-4d4f-8e19-ee1327f46ded
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 08/02/2017
ms.author: apadma
---

## Which versions of Kafka is available on HDInsight?

HDI 3.4	supports Kafka 0.9 (Deprecated)
HDI 3.5	supports Kafka 0.10.0 (Currently in Public Preview)
HDI 3.6	supports Kafka 0.10.1 (Currently in Public Preview)

In these versions, there are two cluster variants:

### OS VHD (No Data Disks)
 This is default Kafka cluster shape that is available to all Kafka preview customers currently.

 The Kafka data (Kafka logs) in this cluster are stored in the OS Disk itself at the default location: /kafka-logs

 Due to the disk size constraints, Kafka is configured to use a maximum of 800GB per node. Please refer to the Kafka TSG on how to change these limits.

### Managed Data Disks
 For more information about managed disks, please refer to this page:  [Managed Disks](https://docs.microsoft.com/en-us/azure/storage/storage-managed-disks-overview)

 Customer provides their required number of data disks per node.

 Each disk is defaulted to size of 1TB, and the customer can choose from 1 through 16, with 16 being the max number of disks. The Azure limitations on maximum number of data disks allowed per VM are still applicable. 
 Reference: [Linux VM Sizes](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/sizes)

### Further Reading:
 [HDInsight Component Versioning](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-component-versioning)
