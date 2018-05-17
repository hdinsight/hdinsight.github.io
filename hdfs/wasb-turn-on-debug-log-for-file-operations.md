---
title: Turn on WASB debug log for file operations | Microsoft Docs
description: How to turn on debug logs just for WASB driver for WASB file operations
keywords: Azure HDInsight, HDFS, WASB, FAQ, troubleshooting guide, common problems, local access
services: Azure HDInsight
documentationcenter: na
author: shzhao
manager: ''
editor: ''

ms.assetid: 1DA360BA-9730-11E7-ABC4-CEC278B6B50A
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 05/16/2018
ms.author: shzhao
---

### Turn on WASB debug log for file operations

#### Overview:

There are times when we are investigating issues with missing files on WASB, we want to understand what operations the WASB driver initiated with Azure Storage. The Azure Storage server side analytics logs can be enabled according to this doc:
https://docs.microsoft.com/en-us/rest/api/storageservices/enabling-storage-logging-and-accessing-log-data

For the client side, the WASB driver produce logs for each file system operation at DEBUG level. WASB driver uses log4j to control logging level and the default is INFO level. To enable debug logs, in general you need to do 2 things:
~~~
1) set level to DEBUG to the per class logger: 
    log4j.logger.org.apache.hadoop.fs.azure.NativeAzureFileSystem
2) set log level to DEBUG for one of the active appenders.
~~~

Note that you can enable debug log for more class if you are interested in those classes. But the NativeAzureFileSystem is producing the basic file system operations like create, delete or rename. Which is usually enough for debugging purpose.

This is an example log produced:
~~~
18/05/13 04:15:55 DEBUG NativeAzureFileSystem: Moving wasb://xxx@yyy.blob.core.windows.net/user/livy/ulysses.txt/_temporary/0/_temporary/attempt_20180513041552_0000_m_000000_0/part-00000 to wasb://xxx@yyy.blob.core.windows.net/user/livy/ulysses.txt/part-00000
~~~

#### Specific instructions

##### HDInsight Spark cluster:

For HDInsight Spark cluster, you can turn on DEBUG log with these steps:

~~~
1) In Ambari UI, click on "Spark2" on the left panel, then click on "Configs" on the right panel.
2) Use "log4j" as the filter to narrow down configurations
3) In "advanced spark2-log4j-properties" and "advanced livy-log4j-properties" configuration,
  modify property:
    log4j.appender.console.Threshold=DEBUG 
  add property:
    log4j.logger.org.apache.hadoop.fs.azure.NativeAzureFileSystem=DEBUG
~~~
