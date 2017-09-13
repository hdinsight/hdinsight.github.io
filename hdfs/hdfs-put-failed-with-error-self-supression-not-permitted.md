---
title: Write to WASB Failed with error self-supression not permitted | Microsoft Docs
description: How to debug a failure with message "self-supression not permitted" when trying to call command "hdfs put"
keywords: Azure HDInsight, HDFS, FAQ, troubleshooting guide, common problems, local access
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
ms.date: 09/11/2017
ms.author: shzhao
---

### Write to WASB Failed with error self-supression not permitted

#### Issue:

For an HDInsight cluster of any cluster type, On hn0, "hadoop fs -ls /" works, "hadoop fs -get /tmp/a.txt" works, but "hadoop fs -put /tmp/a.txt" failed with this exception:
~~~
-put: Self-supression not permitted
Usage: hadoop fs [generit options] -put [-f] [-p] [-l] <localsrc> . . . <dst>
~~~

On hn1, everything works fine.


#### Resolution Steps:

1. On hn0, enable DEBUG logs in console when invoking command:
~~~
hadoop --loglevel DEBUG fs -put b.txt /tmp
~~~

Found the last few lines of error are:
~~~
17/08/25 22:46:35 DEBUG azure.SelfThrottlingIntercept: SelfThrottlingIntercept:: ResponseReceived: threadId=1, Status=202, Elapsed(ms)=8, ETAG=null, contentLength=-1, requestMethod=DELETE
17/08/25 22:46:35 DEBUG azure.NativeAzureFileSystem: Delete Successful for : wasb://lnteccspark-2017-04-07t08-57-11-967z@landtstorageaccount1.blob.core.windows.net/tmp/b.txt._COPYING_
-put: Self-suppression not permitted
~~~

On the good node hn1, it is:
~~~
17/08/25 22:44:21 DEBUG azure.SelfThrottlingIntercept: SelfThrottlingIntercept:: ResponseReceived: threadId=1, Status=202, Elapsed(ms)=9, ETAG=null, contentLength=-1, requestMethod=DELETE
17/08/25 22:44:21 DEBUG azure.NativeAzureFileSystem: Moving wasb://lnteccspark-2017-04-07t08-57-11-967z@landtstorageaccount1.blob.core.windows.net/tmp/b.txt._COPYING_ to wasb://lnteccspark-2017-04-07t08-57-11-967z@landtstorageaccount1.blob.core.windows.net/tmp/b.txt
~~~

This indicates that the code execution path are different for hn0 and hn1.

2. Look at hadoop-azure.jar in folder /usr/hdp/<hdp-version>/hadoop/ on both nodes and they are exactly the same.

3. Then look at Azure Storage dependency jar: azure-storage-xxx.jar:
~~~
$ find /usr/hdp/2.3.3.1-26/ -name "azure-storage*"
/usr/hdp/2.3.3.1-26/spark/lib/azure-storage-2.2.0.jar
…
/usr/hdp/2.3.3.1-26/hadoop/lib/azure-storage-4.2.0.jar
…
~~~

Now we found the culprit, somebody must have manually updated the version of this jar on hn0, causing incompatibility of hadoop-azure and azure-storage jars.
