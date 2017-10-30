---
title: Spark 2.+ applications fails with exceptions when part of oozie workflow launched using Oozie Shell.
description: Use the Spark FAQ for answers to common questions on Spark on Azure HDInsight platform.
keywords: Azure HDInsight, Oozie Shell Action, Spark, troubleshooting guide, SPARK_MAJOR_VERSION
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
ms.date: 10/29/2017
ms.author: sunilkc
---



## Unable to launch Spark Application as a part of oozie workflow using Oozie Shell Action.

### Scenario:
Spark Applications that are part of oozie workflow launched using Oozie Shell Action will fail with one of the following expections on **Spark 2.1+ clusters** and without spark 1.6. Same Spark Application would complete successfully when launched using the spark-submit.

Exceptions: One of these exception will be shown. 
- Exception in thread "main" java.lang.NoSuchMethodError:
- Multiple versions of Spark are installed but SPARK_MAJOR_VERSION is not set
- 	Spark1 will be picked by default
- java.lang.ClassNotFoundException: org.apache.spark.sql.SparkSession

Analyze the logs to find Oozie was trying to launch Spark 1.6 jars instead of spark 2.1 jars. 
Following line is from the [YARN](https://hdinsight.github.io/yarn/yarn-download-logs.html) logs under the “directory.info” section:

~~~~
lrwxrwxrwx 1 yarn hadoop  118 Sep 13 15:36 __spark__.jar -> //mnt/resource/hadoop/yarn/local/usercache/yarn/filecache/12/spark-assembly-1.6.3.2.6.1.10-4-hadoop2.7.3.2.6.1.10-4.jar
~~~~

Oozie triggers the shell actions on anyone of the worker nodes and it appears that when Oozie ran “spark-submit”, it linked the Spark 1.6.3 jar.
Spark Applications submitted using Oozie shell action does not honor SPARK_HOME=/usr/hdp/current/spark2-client and SPARK_MAJOR_VERSION=2 environment variables.

### Recommended changes:
Keep the workflow self-contained so include the full path for the spark-submit and specify the Spark version used

- Use the complete path for the spark-submit in the Workflow.

```xml
<exec>/usr/hdp/current/spark2-client/bin/spark-submit</exec>
```

Instead of 
```xml
<exec>$SPARK_HOME/bin/spark-submit</exec>
```
And

- Add the following to the workflow just before the end tag </shell>

```xml
<env-var>SPARK_MAJOR_VERSION=2</env-var>
```
