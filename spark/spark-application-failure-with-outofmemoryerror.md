---
title: Troubleshoot errors with Apache Spark on Azure HDInsight
description: Use the Spark FAQ for answers to common questions on Spark on Azure HDInsight platform.
author: arijitt
ms.author: arijitt
ms.service: hdinsight
ms.topic: conceptual
ms.custom: troubleshooting
ms.date: 10/29/2018
---
# Troubleshoot errors with Apache Spark on Azure HDInsight

## Scenario: Your Spark application failed with OutOfMemoryError exception

### Issue
You Spark application failed with an OutOfMemoryError unhandled exception. 

```
ERROR Executor: Exception in task 7.0 in stage 6.0 (TID 439) 

java.lang.OutOfMemoryError 
    at java.io.ByteArrayOutputStream.hugeCapacity(Unknown Source) 
    at java.io.ByteArrayOutputStream.grow(Unknown Source) 
    at java.io.ByteArrayOutputStream.ensureCapacity(Unknown Source) 
    at java.io.ByteArrayOutputStream.write(Unknown Source) 
    at java.io.ObjectOutputStream$BlockDataOutputStream.drain(Unknown Source) 
    at java.io.ObjectOutputStream$BlockDataOutputStream.setBlockDataMode(Unknown Source) 
    at java.io.ObjectOutputStream.writeObject0(Unknown Source) 
    at java.io.ObjectOutputStream.writeObject(Unknown Source) 
    at org.apache.spark.serializer.JavaSerializationStream.writeObject(JavaSerializer.scala:44) 
    at org.apache.spark.serializer.JavaSerializerInstance.serialize(JavaSerializer.scala:101) 
    at org.apache.spark.executor.Executor$TaskRunner.run(Executor.scala:239) 
    at java.util.concurrent.ThreadPoolExecutor.runWorker(Unknown Source) 
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(Unknown Source) 
    at java.lang.Thread.run(Unknown Source) 
```

```
ERROR SparkUncaughtExceptionHandler: Uncaught exception in thread Thread[Executor task launch worker-0,5,main] 

java.lang.OutOfMemoryError 
    at java.io.ByteArrayOutputStream.hugeCapacity(Unknown Source) 
    at java.io.ByteArrayOutputStream.grow(Unknown Source) 
    at java.io.ByteArrayOutputStream.ensureCapacity(Unknown Source) 
    at java.io.ByteArrayOutputStream.write(Unknown Source) 
    at java.io.ObjectOutputStream$BlockDataOutputStream.drain(Unknown Source) 
    at java.io.ObjectOutputStream$BlockDataOutputStream.setBlockDataMode(Unknown Source) 
    at java.io.ObjectOutputStream.writeObject0(Unknown Source) 
    at java.io.ObjectOutputStream.writeObject(Unknown Source) 
    at org.apache.spark.serializer.JavaSerializationStream.writeObject(JavaSerializer.scala:44) 
    at org.apache.spark.serializer.JavaSerializerInstance.serialize(JavaSerializer.scala:101) 
    at org.apache.spark.executor.Executor$TaskRunner.run(Executor.scala:239) 
    at java.util.concurrent.ThreadPoolExecutor.runWorker(Unknown Source) 
    at java.util.concurrent.ThreadPoolExecutor$Worker.run(Unknown Source) 
    at java.lang.Thread.run(Unknown Source) 
```

### Probable cause:
The most likely cause of this exception is not enough heap memory. Your Spark application requires enough Java Virtual Machines (JVM) heap memory when running as executors or drivers.

### Resolution:

1. Determine the maximum size of the data the Spark application will handle. Make an estimate of the size based on the maximum of the size of input data, the intermediate data produced by transforming the input data and the output data produced further transforming the intermediate data. If the initial estimate is not sufficient, increase the size slightly, and iterate until the memory errors subside. 

2. Make sure that the HDInsight cluster to be used has enough resources in terms of memory and also cores to accommodate the Spark application. This can be determined by viewing the Cluster Metrics section of the YARN UI of the cluster for the values of Memory Used vs. Memory Total and VCores Used vs. VCores Total.

   ![Yarn core memory view](media/spark-application-failure-with-outofmemoryerror/yarn-core-memory-view.png)

3. Set the following Spark configurations to appropriate values. Balance the application requirements with the available resources in the cluster. These values should not exceed 90% of the available memory and cores as viewed by YARN, and should also meet the minimuim memory requirement of the Spark application:

   ```
   spark.executor.instances (Example: 8 for 8 executor count) 
   spark.executor.memory (Example: 4g for 4 GB) 
   spark.yarn.executor.memoryOverhead (Example: 384m for 384 MB) 
   spark.executor.cores (Example: 2 for 2 cores per executor) 
   spark.driver.memory (Example: 8g for 8GB) 
   spark.driver.cores (Example: 4 for 4 cores)   
   spark.yarn.driver.memoryOverhead (Example: 384m for 384MB) 
   ```

   Total memory used by all executors = 
   ```
   spark.executor.instances * (spark.executor.memory + spark.yarn.executor.memoryOverhead) 
   ``` 
   
   Total memory used by driver = 
   ```
   spark.driver.memory + spark.yarn.driver.memoryOverhead
   ```

## Next steps
For more information on Spark memory management, see the following articles:
1. [Spark memory management overview](http://spark.apache.org/docs/latest/tuning.html#memory-management-overview)
2. [Debugging Spark application on HDInsight clusters](https://blogs.msdn.microsoft.com/azuredatalake/2016/12/19/spark-debugging-101/)
