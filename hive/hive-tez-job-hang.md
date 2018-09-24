---
title: Why does Tez application hang? | Microsoft Docs
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
ms.date: 09/24/2018
ms.author: shzhao
---

#### Issue
After submitting hive job, in Tez view, I see lots of Tez job in "Running" status but doesn't make any progress.

#### Investigation Steps
1. A common problem is that user submitted too many jobs that get queued in the Yarn queue, we need to rule that out first. Go to the Yarn UI (https://<clustername>.azurehdinsight.net/yarnui), and look at "Cluster Metrics" at the top of the UI. Especially the "Apps Pending" field: if this number is big (dozens to hundreds), it indicates that the user has submitted too many Yarn applications (one example is that user use Templeton to submit lots of Hive jobs).

#### Workaround
1. If the root cause is the long Yarn queue. We can scale up the cluster to cope with the situation, or just wait till the Yarn queue is drained. Note that by default "yarn.scheduler.capacity.maximum-applications" controls the maximum number of applications that are running or pending, and it defaults to 10000.



