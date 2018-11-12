---
title: Azure HDInsight Solutions | Apache Spark | Kryo serialization failed exception
description: Learn how to resolve Kryo serialization failed exception when downloading large data sets using Apache Spark Thrift Server.
services: hdinsight
author: confusionblinds
ms.author: sunilkc
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: 11/8/2018
---

# Azure HDInsight Solutions | Apache Spark | Kryo serialization failed exception

## Scenario: When trying to download large data sets using JDBC/ODBC and Thrift Server I get an exception saying, 'Kyro Serialization failed'

## Issue

```java
org.apache.spark.SparkException: Kryo serialization failed: 
Buffer overflow. Available: 0, required: 36518. To avoid this, increase spark.kryoserializer.buffer.max value.
```

## Cause

This exception is caused by the serialization process trying to use more buffer space than is allowed. In Spark 2.0.0 the class `org.apache.spark.serializer.KryoSerializer` is used for serializing objects when data is accessed through Spark SQL Thrift Server. A different class is used for data that will be sent over the network or cached in serialized form.

## Solution

Increase the Kyroserializer buffer value. Add a key named `spark.kryoserializer.buffer.max` and set it to 2048 in spark2 config under "Custom spark2-thrift-sparkconf".