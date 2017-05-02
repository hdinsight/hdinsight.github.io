---
title: How do I analyze Tez Directed Acyclic Graph (DAG) critical path on HDInsight cluster? | Microsoft Docs
description: Use the Hive FAQ for answers to common questions on Hive on Azure HDInsight platform.
keywords: Azure HDInsight, Hive, Tez, FAQ, troubleshooting guide, dag analysis, critical path
services: Azure HDInsight
documentationcenter: na
author: dkakadia
manager: ''
editor: ''

ms.assetid: 1A60BDA1-8613-4A29-B19F-2AEFF11D6A67
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 04/10/2017
ms.author: dkakadia
---

### How do I analyze Tez Directed Acyclic Graph (DAG) critical path on HDInsight cluster?

#### Issue:

Need to analyze Tez DAG information particularly the critical path on HDInsight cluster

#### Resolution Steps:
 
1) Connect to the HDInsight cluster with a Secure Shell (SSH) client (check Further Reading section below).

2) Run the following command at the command prompt:
   
~~~~
hadoop jar /usr/hdp/current/tez-client/tez-job-analyzer-*.jar CriticalPath --saveResults --dagId <DagId> --eventFileName <DagData.zip> 
~~~~

3) List other analyzers that can be used for analyzing Tez DAG with the following command:

~~~
hadoop jar /usr/hdp/current/tez-client/tez-job-analyzer-*.jar
~~~
~~~
An example program must be given as the first argument.
Valid program names are:
  ContainerReuseAnalyzer: Print container reuse details in a DAG
  CriticalPath: Find the critical path of a DAG
  LocalityAnalyzer: Print locality details in a DAG
  ShuffleTimeAnalyzer: Analyze the shuffle time details in a DAG
  SkewAnalyzer: Analyze the skew details in a DAG
  SlowNodeAnalyzer: Print node details in a DAG
  SlowTaskIdentifier: Print slow task details in a DAG
  SlowestVertexAnalyzer: Print slowest vertex details in a DAG
  SpillAnalyzer: Print spill details in a DAG
  TaskConcurrencyAnalyzer: Print the task concurrency details in a DAG
  VertexLevelCriticalPathAnalyzer: Find critical path at vertex level in a DAG
~~~

#### Further Reading:

1) [Connect to HDInsight Cluster using SSH](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-linux-use-ssh-unix)