---
title: Where are the Hive logs on HDInsight cluster? | Microsoft Docs
description: Use the Hive FAQ for answers to common questions on Hive on Azure HDInsight platform.
keywords: Azure HDInsight, Hive, FAQ, troubleshooting guide, log download
services: Azure HDInsight
documentationcenter: na
author: dkakadia
manager: ''
editor: ''

ms.assetid: EF103025-039D-4CD9-A8FB-1DF66C4423AC
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 04/12/2017
ms.author: dkakadia
---

### Where are the  Hive logs on HDInsight cluster?

#### Issue:

Need to find the Hive client, metastore and hiveserver logs on HDInsight cluster.  

#### Resolution Steps: 

1) Connect to the HDInsight cluster with a Secure Shell (SSH) client (check Further Reading section below).


2) Hive client logs can be found at:

~~~
/tmp/<username>/hive.log 
~~~

3) Hive metastore logs can be found at:

~~~
/var/log/hive/hivemetastore.log 
~~~

4) Hiveserver logs can be found at:

~~~
/var/log/hive/hiveserver2.log 
~~~

#### Further Reading:

1) [Connect to HDInsight Cluster using SSH](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-linux-use-ssh-unix)