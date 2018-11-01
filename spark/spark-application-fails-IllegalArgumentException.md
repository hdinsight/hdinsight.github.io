---
title: Azure HDInsight Solutions | Apache Spark | IllegalArgumentException
description: Learn how to resolve an IllegalArgumentException when running Apache Spark jobs using Azure Data Factory.
services: hdinsight
author: confusionblinds
ms.author: sunilkc
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: 10/30/2018
---
# Azure HDInsight Solutions | Spark | IllegalArgumentException

## Scenario: Spark activity running in Azure Data Factory fails with IllegalArgumentException

## Issue

You receive the following exception when trying to execute a Spark activity in an Azure Data Factory pipeline:

```java
Exception in thread "main" java.lang.IllegalArgumentException: 
Wrong FS: wasbs://additional@xxx.blob.core.windows.net/spark-examples_2.11-2.1.0.jar, expected: wasbs://wasbsrepro-2017-11-07t00-59-42-722z@xxx.blob.core.windows.net
```

## Cause

A Spark job will fail if the application jar file is not located in the Spark cluster’s default/primary storage.

This is a known issue with the Spark open source framework tracked in this bug: [Spark job fails if fs.defaultFS and application jar are different url](https://issues.apache.org/jira/browse/SPARK-22587)

This issue has been resolved in Spark 2.3.0

## Solution

Make sure the application jar is stored on the default/primary storage for the HDInsight cluster. In case of Azure Data Factory make sure the ADF linked service is pointed to the HDInsight default container rather than a secondary container.