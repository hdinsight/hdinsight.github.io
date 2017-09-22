---
title: Configure heap memory for Spark History UI | Microsoft Docs
description: Use the Spark FAQ for answers to common questions on Spark on Azure HDInsight platform.
keywords: Azure HDInsight, Spark History UI, troubleshooting, common problems
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
ms.date: 09/18/2017
ms.author: sunilkc
---



###Getting following " java.lang.OutOfMemoryError: Java heap space" error when we trying to open spark history server 

 #### Detail error message:
 ~~~~
 
scala.MatchError: java.lang.OutOfMemoryError: Java heap space (of class java.lang.OutOfMemoryError)
	at org.apache.spark.deploy.history.HistoryServer.org$apache$spark$deploy$history$HistoryServer$$loadAppUi(HistoryServer.scala:230)
	at org.apache.spark.deploy.history.HistoryServer$$anon$1.doGet(HistoryServer.scala:86)
	at javax.servlet.http.HttpServlet.service(HttpServlet.java:687)
	at javax.servlet.http.HttpServlet.service(HttpServlet.java:790)
	at org.spark_project.jetty.servlet.ServletHolder.handle(ServletHolder.java:812)
	at org.spark_project.jetty.servlet.ServletHandler.doHandle(ServletHandler.java:587)
	at org.spark_project.jetty.server.handler.ContextHandler.doHandle(ContextHandler.java:1127)
	at org.spark_project.jetty.servlet.ServletHandler.doScope(ServletHandler.java:515)
	at org.spark_project.jetty.server.handler.ContextHandler.doScope(ContextHandler.java:1061)
	at org.spark_project.jetty.server.handler.ScopedHandler.handle(ScopedHandler.java:141)
	at org.spark_project.jetty.servlets.gzip.GzipHandler.handle(GzipHandler.java:529)
	at org.spark_project.jetty.server.handler.ContextHandlerCollection.handle(ContextHandlerCollection.java:215)
	at org.spark_project.jetty.server.handler.HandlerWrapper.handle(HandlerWrapper.java:97)
	at org.spark_project.jetty.server.Server.handle(Server.java:499)
	at org.spark_project.jetty.server.HttpChannel.handle(HttpChannel.java:311)
	at org.spark_project.jetty.server.HttpConnection.onFillable(HttpConnection.java:257)
	at org.spark_project.jetty.io.AbstractConnection$2.run(AbstractConnection.java:544)
	at org.spark_project.jetty.util.thread.QueuedThreadPool.runJob(QueuedThreadPool.java:635)
	at org.spark_project.jetty.util.thread.QueuedThreadPool$3.run(QueuedThreadPool.java:555)
	at java.lang.Thread.run(Thread.java:748)
	~~~~
#### Probable Causes:
##### Look for the size of the spark events
~~~~
hadoop fs -du -s -h wasb:///hdp/spark2-events/application_1503957839788_0274_1/
**576.5 M**  wasb:///hdp/spark2-events/application_1503957839788_0274_1

hadoop fs -du -s -h wasb:///hdp/spark2-events/application_1503957839788_0264_1/
**2.1 G**  wasb:///hdp/spark2-events/application_1503957839788_0264_1
~~~~

If the issue is often seen when opening a large spark event files better to increase the value for  **SPARK_DAEMON_MEMORY**, default value is set to 1g. You can increase the historyServer memory by adding SPARK_DAEMON_MEMORY=4g in the content and restarting all the services

#### Resolution:
##### Steps to set the value for **SPARK_DAEMON_MEMORY**
Increase the Spark History Server heap size to 3 or 4 GB depending on the size of the spark events you are opening.  
![Alt text](media/spark-spark-history-failure-with-outofmemoryerror/image01.png)

You can do this from within Ambari browser GUI by selecting Spark2/Config/Advanced spark2-env
Then find content key and add the following to change the Spark History Server memory from 1g to 4g
~~~~


----------


SPARK_DAEMON_MEMORY=4g
~~~~
![Alt text](media/spark-spark-history-failure-with-outofmemoryerror/image01.png)



