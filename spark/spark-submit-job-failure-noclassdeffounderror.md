---
title: Azure HDInsight Solutions | Apache Spark | spark-submit job failed with NoClassDefFoundError
description: Learn how to resolve spark-submit job failed with NoClassDefFoundError
services: hdinsight
author: confusionblinds
ms.author: sunilkc
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: 11/12/2018
---

# Azure HDInsight Solutions | Apache Spark | spark-submit job failed with NoClassDefFoundError

## Scenario: An Apache Spark streaming job that reads data from a Kafka cluster fails with a NoClassDefFoundError

## Issue

The Spark cluster runs a spark streaming job that reads data from Kafka cluster. The spark streaming job fails if the kafka stream compression is turned on. In this case, the spark streaming yarn app application_1525986016285_0193 failed, due to error:
~~~~
18/05/17 20:01:33 WARN YarnAllocator: Container marked as failed: container_e25_1525986016285_0193_01_000032 on host: wn87-Scaled.2ajnsmlgqdsutaqydyzfzii3le.cx.internal.cloudapp.net. Exit status: 50. Diagnostics: Exception from container-launch.
Container id: container_e25_1525986016285_0193_01_000032
Exit code: 50
Stack trace: ExitCodeException exitCode=50: 
 at org.apache.hadoop.util.Shell.runCommand(Shell.java:944)
~~~~

## Cause

This error can be caused by specifying a version of the `spark-streaming-kafka` jar file that is different than the version of the Kafka cluster you are running.

For example, if you are running a Kafka cluster version 0.10.1, the following command will result in an error:

```bash
spark-submit \
--packages org.apache.spark:spark-streaming-kafka-0-8_2.11:2.2.0
--conf spark.executor.instances=16 \
...
~/Kafka_Spark_SQL.py <bootstrap server details>
```

## Solution

Use the spark-submit command with the --packages option, and ensure that the version of the spark-streaming-kafka jar file is the same as the version of the Kafka cluster that you are running.