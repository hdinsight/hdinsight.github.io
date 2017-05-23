---
title: Where can I find Storm-EventHub-Spout binaries for development? | Microsoft Docs
description: Use the Storm FAQ for answers to common questions on Storm on Azure HDInsight platform.
keywords: Azure HDInsight, Storm, FAQ, troubleshooting guide, common problems, EventHubs
services: Azure HDInsight
documentationcenter: na
author: raviperi
manager: ''
editor: ''

ms.assetid: A045B79E-7BC0-4F23-B0DF-31D0F2DEEBB1
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 05/14/2017
ms.author: raviperi
---

## Where can I find Storm-EventHub-Spout binaries for development?

### Issue:
How can I find out more about using Storm eventhub spout jars for use with my topology.

#### MSDN articles on how-to

##### Java based topology
https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-storm-develop-java-event-hub-topology

##### C# based topology (using Mono on HDI 3.4+ Linux Storm clusters)
https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-storm-develop-csharp-event-hub-topology

##### Latest Storm EventHub spout binaries for HDI3.5+ Linux Storm clusters
Please look at https://github.com/hdinsight/mvn-repo/blob/master/README.md for how to use the latest 
Storm eventhub spout that works with HDI3.5+ Linux Storm clusters.

##### Source Code examples:
https://github.com/Azure-Samples/hdinsight-java-storm-eventhub

