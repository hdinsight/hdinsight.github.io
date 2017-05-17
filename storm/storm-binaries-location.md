---
title: Where are the Storm Binaries on HDInsight cluster? | Microsoft Docs
description: Use the Storm FAQ for answers to common questions on Storm on Azure HDInsight platform.
keywords: Azure HDInsight, Storm, FAQ, troubleshooting guide, common problems
services: Azure HDInsight
documentationcenter: na
author: raviperi
manager: ''
editor: ''

ms.assetid: 6609C3DF-0B41-46DC-B7D4-D8FAC4E05347
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 05/14/2017
ms.author: raviperi
---

## Where are the Storm Binaries on HDInsight cluster?

### Issue:
 Know location of binaries for Storm services on HDInsight cluster

### Resolution Steps:

Storm binaries for current HDP Stack can be found at:
 /usr/hdp/current/storm-client

This location is the same for Headnodes as well as worker nodes.
 
There may be multiple HDP version specific binaries located under /usr/hdp
(example: /usr/hdp/2.5.0.1233/storm)

But the /usr/hdp/current/storm-client is sym-linked to the latest version that is run on the cluster.

### Further Reading:
 [Connect to HDInsight Cluster using SSH](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-linux-use-ssh-unix)
 [Storm](http://storm.apache.org/)
