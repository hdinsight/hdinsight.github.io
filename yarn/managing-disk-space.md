---
title: What do I do when Yarn node managers show unhealthy status as disks are full? | Microsoft Docs
description: Use the Yarn FAQ for answers to common questions on Yarn on Azure HDInsight platform.
keywords: Azure HDInsight, Yarn, FAQ, troubleshooting guide, unhealthy nodemanager, full disks
services: Azure HDInsight
documentationcenter: na
author: nielango
manager: ''
editor: ''

ms.assetid: 
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 06/29/2018
ms.author: nielango

---

### What do I do when Yarn NMs show unhealthy status as disks are full?

#### Issue:

Yarn node managers show unhealthy status since disks are full. Applications are hanging owing to this. 

#### Resolution Steps: 

1) Check if the following settings are set correctly as they could cause the local directory to fill up.
	- Ensure that yarn.log-aggregation-enabled is enabled. If disabled, NMs will keep the logs locally and not aggregate them in remote store on application completion or termination.
	- Cache also uses disk space. Ensure that yarn.nodemanager.localizer.cache.cleanup.interval-ms (default 10 mins) and yarn.nodemanager.localizer.cache.target-size-mb (default 10240 MB) are not set to very high values.

2) Ensure that the cluster size is appropriate for the workload. The workload might have changed reecently or the cluster might have been resized. Scale up the cluster to match a higher workload.
3) /mnt/resource might also be filled with orphaned files (as in the case of RM restart). Manually cleaning up /mnt/resource/hadoop/yarn/log and /mnt/resource/hadoop/yarn/local would help in this scenario.