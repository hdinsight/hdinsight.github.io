---
title: Azure HDInsight Solutions | Apache Spark | 502 Errors Connecting to Thrift server
description: Learn how to resolve 502 errors when connecting to Apache Spark Thrift server
services: hdinsight
author: confusionblinds
ms.author: sunilkc
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: 11/1/2018
---

# Azure HDInsight Solutions | Apache Spark | 502 Errors Connecting to Thrift server

## Scenario: You see 502 errors when processing large data sets using Apache Spark thrift server

## Issue

Spark application fails with a `org.apache.spark.rpc.RpcTimeoutException` exception and a message: `Futures timed out`, as in the following example:

```java
org.apache.spark.rpc.RpcTimeoutException: Futures timed out after [120 seconds]. This timeout is controlled by spark.rpc.askTimeout
 at org.apache.spark.rpc.RpcTimeout.org$apache$spark$rpc$RpcTimeout$$createRpcTimeoutException(RpcTimeout.scala:48)
```

`OutOfMemoryError` and `overhead limit exceeded` errors may also appear in the `sparkthriftdriver.log` as in the following example:

```java
WARN  [rpc-server-3-4] server.TransportChannelHandler: Exception in connection from /10.0.0.17:53218
java.lang.OutOfMemoryError: GC overhead limit exceeded
```

## Cause

These errors is caused by a lack of memory resources during data processing. If the Java garbage collection process starts, it could lead to the Spark application hanging. Queries will begin to timeout and stop processing. The `Futures timed out` error indicates a cluster under severe stress. 

## Solution

You should increase the cluster size by adding more worker nodes or increasing the memory capacity of the existing cluster nodes. You can also adjust the data pipeline to reduce the amount of data being processed at once.

The `spark.network.timeout` controls the timeout for all network connections. Increasing the network timeout may allow more time for some critical operations to finish, but this will not resolve the issue completely.