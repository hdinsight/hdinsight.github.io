---
title: how to access wasb? | Microsoft Docs
description: Use the Spark FAQ for answers to common questions on Spark on Azure HDInsight platform.
keywords: Azure HDInsight, FAQ, troubleshooting guide, common problems, accessing folder
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
ms.date: 02/01/2018
ms.author: sunilkc
---

This article capture 

### How to access blob store from jupyterthat is not part of HDInsight cluster?

Scala syntax

```
sc.hadoopCconfiguration.set("fs.azure.account.keyprovider.{blobname}.blob.core.windows.net","org.apache.hadoop.fs.azure.SimpleKeyProvider")
sc.hadoopConfiguration.set("fs.azure.account.key.{blobname}.blob.core.windows.net","{storagekey==}")

spark.read.csv("wasb://{containername}@{blobname}.blob.core.windows.net/students/students.csv").show()


+-----+------+
|  _c0|   _c1|
+-----+------+
| Name| Marks|
| John|    34|
|  Jim|    66|
|Emily|    56|
| Nina|    89|
|Susan|    55|
| Fred|    99|
| Rick|    56|
+-----+------+

```

PySpark as :

```
spark._jsc.hadoopConfiguration().set("fs.azure.account.keyprovider.{blobname}.blob.core.windows.net","org.apache.hadoop.fs.azure.SimpleKeyProvider")
spark._jsc.hadoopConfiguration().set("fs.azure.account.key.{blobname}.blob.core.windows.net","{storagekey==}")
spark.read.csv("wasb://{containername}@{blobname}.blob.core.windows.net/students/students.csv").show()
```

### How to access windows azure storage blob from within scala application?

One can use following syntax to access the default storage account from Spark cluster using scala

```
scala> val fs = org.apache.hadoop.fs.FileSystem.get(new java.net.URI("wasb:///"),sc.hadoopConfiguration)
fs: org.apache.hadoop.fs.FileSystem = org.apache.hadoop.fs.azure.NativeAzureFileSystem@5edd9b4f

scala> fs.delete(new org.apache.hadoop.fs.Path("/deletethis"),true)
res3: Boolean = true

scala> fs.delete(new org.apache.hadoop.fs.Path("/log.txt"),false)
```

