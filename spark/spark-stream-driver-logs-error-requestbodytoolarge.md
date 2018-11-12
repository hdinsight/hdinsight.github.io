---
title: Azure HDInsight Solutions | Apache Spark | Spark streaming app NativeAzureFileSystem ... RequestBodyTooLarge error
description: Learn how to resolve NativeAzureFileSystem ... RequestBodyTooLarge errors in the Apache Spark streaming app driver log.
services: hdinsight
author: confusionblinds
ms.author: sunilkc
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: 11/12/2018
---

# Azure HDInsight Solutions | Apache Spark | Spark streaming app NativeAzureFileSystem ... RequestBodyTooLarge error

## Scenario: An Apache Spark streaming app with Windows Azure Storage Blob (WASB) as default storage throws the error NativeAzureFileSystem ... RequestBodyTooLarge in the driver log.

## Issue

The error: `NativeAzureFileSystem ... RequestBodyTooLarge` appears in the driver log for a Spark streaming app.

## Cause

Your Spark event log file is probably hitting the file length limit for WASB.

In Spark 2.3, each Spark app generates 1 Spark event log file. The Spark event log file for a Spark streaming app continues to grow while the app is running. Today a file on WASB has a 50000 block limit, and the default block size is 4MB. So in default configuration the max file size is 195GB. However, Azure storage has increased the max block size to 100MB, which effectively brought the single file limit to 4.75TB. See [Azure Storage Scalability and Performance Targets](https://docs.microsoft.com/en-us/azure/storage/common/storage-scalability-targets) for more information.

## Solution

There are three solutions available for this error:

1. Increase the block size to up to 100MB. In Ambari UI, modify HDFS configuration property `fs.azure.write.request.size` (or create it in `Custom core-site` section). Set the property to a larger value, for example: 33554432. Save the updated configuration and restart affected components.

2. Periodically stop and resubmit the spark-streaming job.

3. Use HDFS to store Spark event logs. To do this, complete the following steps.

    > [!Note]
    > Using HDFS for storage may result in loss of Spark event data during cluster scaling or Azure upgrades.
    
    1. Make changes to `spark.eventlog.dir` and `spark.history.fs.logDirectory` via Ambari UI:
    
    ```config
    spark.eventlog.dir = hdfs://mycluster/hdp/spark2-events
    spark.history.fs.logDirectory = "hdfs://mycluster/hdp/spark2-events"
    ```
    
    2. Create directories on HDFS:
    
    ```bash
    hadoop fs -mkdir -p hdfs://mycluster/hdp/spark2-events
    hadoop fs -chown -R spark:hadoop hdfs://mycluster/hdp
    hadoop fs -chmod -R 777 hdfs://mycluster/hdp/spark2-events
    hadoop fs -chmod -R o+t hdfs://mycluster/hdp/spark2-events
    ```
    
    3. Restart all affected services via Ambari UI.