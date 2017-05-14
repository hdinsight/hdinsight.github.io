---
title: What is the deployment topology of HDInsight Storm cluster? | Microsoft Docs
description: Use the Storm FAQ for answers to common questions on Storm on Azure HDInsight platform.
keywords: Azure HDInsight, Storm, FAQ, troubleshooting guide, cluster components
services: Azure HDInsight
documentationcenter: na
author: raviperi
manager: ''
editor: ''

ms.assetid: F0B0ED75-DA6A-434E-BCA4-B05471BD387B
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 05/14/2017
ms.author: raviperi
---
### What is the deployment topology of HDInsight Storm cluster?

#### Issue:

Identify all components that are installed with HDInsight Storm.

Storm cluster comprises of 4 node categories
1) Gateway
2) Head nodes
3) Zookeeper nodes
4) Worker nodes

##### Gateway nodes
Is an gateway and reverse proxy service that enables public access to active Ambari management service, handles Ambari Leader election.

#### Zookeeper Nodes
HDInsight comes with a 3 node Zookeeper quorum.
The quorum size is fixed, and is not configurable.

Storm services in the cluster are configured to use the ZK quorum automatically.

##### Head Nodes
Storm head nodes run the following services:
1) Nimbus
2) Ambari server
3) Ambari Metrics Server
4) Ambari Metrics collector

#### Worker Nodes
Storm worker nodes run the following services:
1) Supervisor
2) Worker JVMs for running topologies
3) Ambari Agent
