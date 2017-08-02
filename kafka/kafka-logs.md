---
title: TSG: Where are Kafka logs on HDInsight cluster | Microsoft Docs
description: Use the Kafka FAQ for answers to common questions on Kafka on Azure HDInsight platform.
keywords: Azure HDInsight, Kafka, FAQ, troubleshooting guide, common problems
services: Azure HDInsight
documentationcenter: na
author: apadma
manager: ''
editor: ''

ms.assetid: cd6bcbab-8d8c-4b56-94f0-58783f93787e
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 08/02/2017
ms.author: apadma
---

## Where are Kafka logs on HDInsight cluster

Kafka logs in the cluster are located at: ```/var/log/kafka```

kafka.out:	
stdout and stderr of the Kafka process.	
You will find Kafka startup and shutdown logs in this file. 

server.log:	
The main Kafka server log.	
All Kafka broker logs end up here.

controller.log:
Controlelr logs if the broker is acting as controller.

statechange.log:
All state change events to brokers are logged in this file.

kafka-gc.log:
Kafka Garbage Collection stats

