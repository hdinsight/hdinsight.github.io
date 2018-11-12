---
title: Azure HDInsight Solutions | Apache Spark | Streaming jobs are slow
description: Learn how to resolve slow Apache Spark streaming jobs
services: hdinsight
author: confusionblinds
ms.author: sunilkc
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: 11/12/2018
---

# Azure HDInsight Solutions | Apache Spark | Streaming jobs are slow

## Scenario: Spark Streaming jobs take longer than usual to process

## Issue

You observe that some of the HDInsight Spark Streaming jobs are slow, or taking longer than usual to process. For Spark Streaming applications, each batch of messages corresponds to one job submitted to Spark. If a job normally takes X seconds to process, it may occasionally take 2-3 minutes more than usual.

## Cause

1. One possible cause is that the Kafka producer takes more than 2 minutes to finish writing out to the Kafka cluster. To further debug the Kafka issue, you can add some logging to the code that uses a Kafka producer to send out messages, and correlate that with the logs from Kafka cluster.

2. Another possible cause is that frequent reads and writes to WASB can cause subsequent micro-batches to lag. The WASB implementation of `Filesystem.listStatus` is very slow due to an O(n!) algorithm to remove duplicates. It uses too much memory due to the extra conversion from `BlobListItem` to `FileMetadata` to `FileStatus`. For example, the algorithm takes over 30 minutes to list 700,000 files. So if `ListBlobs` is being called aggressively by SparkSQL every micro-batch, it will cause subsequent micro-batches to lag behind resulting in what you experience as high scheduling delays. [This patch](https://issues.apache.org/jira/browse/HADOOP-15547) fixes the issue, but if it is missing in your environment, ListBlobs will experience high latency. Also, even if you delete files every hour, the listing in the back-end has to iterate over all rows (including deleted) because garbage collection process hasn't completed yet. While the patch might solve some of the problem, the garbage collection issue might still cause delay in stream processing of batches.

## Solution

Apply the [HADOOP-15547](https://issues.apache.org/jira/browse/HADOOP-15547) fix.  If that is not possible, you can use HDFS as the check point location. Set `checkpointDirectory` to something like: "hdfs://mycluster/checkpoint"