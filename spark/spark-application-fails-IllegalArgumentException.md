---
title: Why did my Spark application fail with IllegalArgumentException Wrong FS? | Microsoft Docs
description: Use the Spark FAQ for answers to common questions on Spark on Azure HDInsight platform.
keywords: Azure HDInsight, Thrift Server, FAQ, troubleshooting guide, common problems, default serialization, kyro, remote submission
services: Azure HDInsight
documentationcenter: na
author: Sunilkc
manager: ''
editor: ''

ms.assetid: 
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 03/14/2018
ms.author: sunilkc
---

### Why did my Spark application fail with IllegalArgumentException Wrong FS?

#### Issue
Getting following exception when trying to execute a Sparkactivity Pipeline part of Azure Data Factory
Exception in thread "main" java.lang.IllegalArgumentException: Wrong FS: wasbs://additional@xxx.blob.core.windows.net/spark-examples_2.11-2.1.0.jar, expected: wasbs://wasbsrepro-2017-11-07t00-59-42-722z@xxx.blob.core.windows.net 

#### Issue could be reproduced with the application file (jar / py) stored on a non-default container part of the default storage and the storage is enable for secure transfer

	Blob storage : http:///xxx.blob.core.windows.net 
	Default container : wasbsrepro-2017-11-07t00-59-42-722z 
	Addictional Container: http:///xxx.blob.core.windows.net/additional 

#### Cause:This is a known issue with the Spark open source framework tracked here: https://issues.apache.org/jira/browse/SPARK-22587
Spark job will fail if application jar is not located in the Spark cluster’s default/primary storage. 
	
#### Mitigation: Make sure the application jar is stored on the primary storage  	
In case of Azure Data Factory make sure the ADF linked service is pointed to the HDI default container rather than a secondary container.
