---
title: Users can experience 502 errors intermittently when processing large data over Spark thrift server | Microsoft Docs
description: 
keywords: Azure HDInsight, Spark, FAQ, troubleshooting guide, common problems, remote submission
services: Azure HDInsight
documentationcenter: na
author: sunilkc
manager: ''
editor: ''
---

### Users start experiencing 502 errors frequently when trying to connect to Thrift server exposed by HDInsight cluster:
Error: org.apache.thrift.transport.TTransportException: HTTP Response code: 502
SQLState:  08S01
ErrorCode: 0

Spark thrift server uses Spark SQL Engine which in turn uses full spark capabilities.
Spark Thrift Server is primarily to run Queries on Spark SQL using ODBC or JDBC interface.
  
#### Issue:
Spark application fails with the following exception with Futures timed out.

~~~~
org.apache.spark.rpc.RpcTimeoutException: Futures timed out after [120 seconds]. This timeout is controlled by spark.rpc.askTimeout
 at org.apache.spark.rpc.RpcTimeout.org$apache$spark$rpc$RpcTimeout$$createRpcTimeoutException(RpcTimeout.scala:48)
 at org.apache.spark.rpc.RpcTimeout$$anonfun$addMessageIfTimeout$1.applyOrElse(RpcTimeout.scala:63)
 at org.apache.spark.rpc.RpcTimeout$$anonfun$addMessageIfTimeout$1.applyOrElse(RpcTimeout.scala:59)
 at scala.PartialFunction$OrElse.apply(PartialFunction.scala:167)
 at org.apache.spark.rpc.RpcTimeout.awaitResult(RpcTimeout.scala:83)
 at org.apache.spark.rpc.RpcEndpointRef.askWithRetry(RpcEndpointRef.scala:102)
 at org.apache.spark.rpc.RpcEndpointRef.askWithRetry(RpcEndpointRef.scala:78)
 at org.apache.spark.executor.CoarseGrainedExecutorBackend$$anonfun$run$1.apply$mcV$sp(CoarseGrainedExecutorBackend.scala:203)
 at org.apache.spark.deploy.SparkHadoopUtil$$anon$1.run(SparkHadoopUtil.scala:67)
 at org.apache.spark.deploy.SparkHadoopUtil$$anon$1.run(SparkHadoopUtil.scala:66)
 at java.security.AccessController.doPrivileged(Native Method)
 at javax.security.auth.Subject.doAs(Subject.java:422)
 at org.apache.hadoop.security.UserGroupInformation.doAs(UserGroupInformation.java:1866)
 at org.apache.spark.deploy.SparkHadoopUtil.runAsSparkUser(SparkHadoopUtil.scala:66)
 at org.apache.spark.executor.CoarseGrainedExecutorBackend$.run(CoarseGrainedExecutorBackend.scala:188)
 at org.apache.spark.executor.CoarseGrainedExecutorBackend$.main(CoarseGrainedExecutorBackend.scala:284)
 at org.apache.spark.executor.CoarseGrainedExecutorBackend.main(CoarseGrainedExecutorBackend.scala)
Caused by: java.util.concurrent.TimeoutException: Futures timed out after [120 seconds]
 at scala.concurrent.impl.Promise$DefaultPromise.ready(Promise.scala:219)
 at scala.concurrent.impl.Promise$DefaultPromise.result(Promise.scala:223)
 at scala.concurrent.Await$$anonfun$result$1.apply(package.scala:190)
~~~~
 
Looking through sparkthriftdriver.log if you also observe any OutOfMemoryError
The log shows GC overhead limit exceeded errors occurring off and on when the issue was reported problem:
~~~~
WARN  [rpc-server-3-4] server.TransportChannelHandler: Exception in connection from /10.0.0.17:53218
java.lang.OutOfMemoryError: GC overhead limit exceeded
WARN  [rpc-server-3-4] channel.DefaultChannelPipeline: An exception 'java.lang.OutOfMemoryError: GC overhead limit exceeded' [enable DEBUG level for full stacktrace] was thrown by a user handler's exceptionCaught() method while handling the following exception:
java.lang.OutOfMemoryError: GC overhead limit exceeded
ERROR [pool-28-thread-37] thriftserver.SparkExecuteStatementOperation: Error executing query, currentState RUNNING, 
java.lang.OutOfMemoryError: GC overhead limit exceeded
ERROR [pool-28-thread-37] thriftserver.SparkExecuteStatementOperation: Error running hive query: 
org.apache.hive.service.cli.HiveSQLException: java.lang.OutOfMemoryError: GC overhead limit exceeded
~~~~ 

#### Scenario:
Issue was observed when running Select Query processing a Table of 80GB of data.
 
#### Troubleshooting Steps:
Note the Application ID that were processing the jobs from the Spark UI and look for above exceptions in the sparkthriftdriver.log.

* While processing large dataset, if Garbage Collection occurs this could eventually lead to Spark Application getting hung. 
* Queries would eventually time out and no longer moving through the system.
* “Futures timed out” error is symptomatic of a cluster under severe stress.
* spark.network.timeout value drive all the timeout for all network interactions.
* Increasing the spark.network.timeout value would allow more time for critical operations to complete but would not be a complete resolution rather increasing memory would certainly help.
* As the size of the data to be processed is increased you will be forced to increase the time out as the memory is already at a premium.
 
#### Resolution:
* Increasing the size of the cluster would certainly help. 
* But if you are continuing to experience this symptom, it is suggested to revisit how you can avoid processing such large set of data.

