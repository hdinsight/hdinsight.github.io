---
title: Azure HDInsight Solutions | Kafka | Common How-to 
description: Learn titbits on troubleshooting kafka
services: hdinsight
author: csunilkumar
ms.author: sunilkc
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: <date>
---

# Azure HDInsight Solutions | Kafka | Common How-to

## 1. How to get the lag per partition/topic for a given consumer ?
- run the following command to return the lag per topic/partition for the consumer group id passed.

  `` usr/hdp/current/kafka-broker/bin$ ./kafka-consumer-groups.sh --zookeeper <zknode>:2181 --describe --group <consumer-groupid> ``

  Note: This will only show information about consumers that use ZooKeeper (not those using the Java consumer API).
