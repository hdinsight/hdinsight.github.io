---
title: How do I launch Hive shell with specific configurations on HDInsight cluster? | Microsoft Docs
description: Use the Hive FAQ for answers to common questions on Hive on Azure HDInsight platform.
keywords: Azure HDInsight, Hive, FAQ, troubleshooting guide, hive shell, launch configurations
services: Azure HDInsight
documentationcenter: na
author: dkakadia
manager: ''
editor: ''

ms.assetid: 5F1A2159-25D4-41E9-819D-DAADF338DE6C
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 04/12/2017
ms.author: dkakadia
---

### How do I launch Hive shell with specific configurations on HDInsight cluster?

#### Issue:

Need to override or specify Hive shell configurations at launch time on HDInsight clusters.  

#### Resolution Steps: 

1) Specify a configuration key value pair while starting Hive shell (check Further Reading section below):

~~~~
hive -hiveconf a=b 
~~~~

2) List all effective configurations on Hive shell with the following command:

~~~
hive> set;
~~~

For example, use the following command to start hive shell with debug logging enabled on console:
             
~~~
hive -hiveconf hive.root.logger=ALL,console 
~~~

#### Further Reading:

1) [Hive configuration properties](https://cwiki.apache.org/confluence/display/Hive/Configuration+Properties)