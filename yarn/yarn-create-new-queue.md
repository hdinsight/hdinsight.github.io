---
title: How do I create new Yarn queue on HDInsight cluster? | Microsoft Docs
description: Use the Yarn FAQ for answers to common questions on Yarn on Azure HDInsight platform.
keywords: Azure HDInsight, Yarn, FAQ, troubleshooting guide, create queue
services: Azure HDInsight
documentationcenter: na
author: arijitt
manager: ''
editor: ''

ms.assetid: F76786A9-99AB-4B85-9B15-CA03528FC4CD
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 04/07/2017
ms.author: arijitt

---

### How do I create new Yarn queue on HDInsight cluster?

#### Issue:

Need to create a new Yarn queue with capacity allocation on HDInsight cluster.  

#### Resolution Steps: 

1. Use the following steps through Amabari to create a new Yarn queue and balance the capacity allocation 
among all the queues.


![Alt text](media/yarn-create-new-queue/yarn-create-queue-step-1.png)
![Alt text](media/yarn-create-new-queue/yarn-create-queue-step-2.png)
![Alt text](media/yarn-create-new-queue/yarn-create-queue-step-3.png)
![Alt text](media/yarn-create-new-queue/yarn-create-queue-step-4.png)
![Alt text](media/yarn-create-new-queue/yarn-create-queue-step-5.png)
![Alt text](media/yarn-create-new-queue/yarn-create-queue-step-6.png)
![Alt text](media/yarn-create-new-queue/yarn-create-queue-step-7.png)
![Alt text](media/yarn-create-new-queue/yarn-create-queue-step-8.png)
![Alt text](media/yarn-create-new-queue/yarn-create-queue-step-9.png)
![Alt text](media/yarn-create-new-queue/yarn-create-queue-step-10.png)
![Alt text](media/yarn-create-new-queue/yarn-create-queue-step-11.png)
![Alt text](media/yarn-create-new-queue/yarn-create-queue-step-12.png)
![Alt text](media/yarn-create-new-queue/yarn-create-queue-step-13.png)
![Alt text](media/yarn-create-new-queue/yarn-create-queue-step-14.png)
![Alt text](media/yarn-create-new-queue/yarn-create-queue-step-15.png)

Note: These changes will be visible immediately on the Yarn Scheduler UI.

#### Further Reading:

1) [Yarn Capacity Scheduler](https://hadoop.apache.org/docs/r2.7.2/hadoop-yarn/hadoop-yarn-site/CapacityScheduler.html)
