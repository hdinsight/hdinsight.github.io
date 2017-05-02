---
title: How do I download Tez Directed Acyclic Graph (DAG) data from HDInsight cluster? | Microsoft Docs
description: Use the Hive FAQ for answers to common questions on Hive on Azure HDInsight platform.
keywords: Azure HDInsight, Hive, Tez, FAQ, troubleshooting guide, dag analysis, critical path
services: Azure HDInsight
documentationcenter: na
author: dkakadia
manager: ''
editor: ''

ms.assetid: 15B8D0F3-F2D3-4746-BDCB-C72944AA9252
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 04/10/2017
ms.author: dkakadia
---

### How do I download Tez Directed Acyclic Graph (DAG) data from HDInsight cluster?

#### Issue:

Need to download Tez DAG information from HDInsight cluster

#### Resolution Steps:

There are two ways to collect the Tez DAG data.

1) From commandline:
 
1.1) Connect to the HDInsight cluster with a Secure Shell (SSH) client (check Further Reading section below).

1.2) Run the following command at the command prompt:
   
~~~~
    hadoop jar /usr/hdp/current/tez-client/tez-history-parser-*.jar org.apache.tez.history.ATSImportTool -downloadDir . -dagId <DagId> 
~~~~

2) From Ambari Tez view:
   
Go to Ambari --> Go to Tez view (hidden under tiles icon in upper right corner) --> Click on the dag you are interested in --> Click on Download data.

#### Further Reading:

1) [Connect to HDInsight Cluster using SSH](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-linux-use-ssh-unix)