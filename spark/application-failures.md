---
title: Azure HDInsight Solutions | Apache Spark | IllegalArgumentException
description: Learn how to resolve an IllegalArgumentException when running Apache Spark jobs using Azure Data Factory.
services: hdinsight
author: csunilkumar
ms.author: sunilkc
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: 01/17/2019
---
# Azure HDInsight Solutions | Spark | General Troubleshooting Guidelines

## Troubleshooting Spark Application Failures

   Note : This document covers exceptions and explains appilcation behaviours inferred using YARN logs

## Issue: 

Spark application fails following exception.
``` 
py4j.protocol.Py4JJavaError: An error occurred while calling o93.count.
: org.apache.spark.SparkException: Job 2 cancelled because SparkContext was shut down
```

1. Identify the time of failure, use YARN UI to identify failed application, note the application start and end date & time.
2. Download YARN logs for that failed application containing all the containers.
   -  [How do I download Yarn logs from HDInsight cluster?](/yarn/yarn-download-logs.html), this article details different options to capture YARN Logs.
   -  Download all AM logs into different file, make it easier to search only drivers log.
3.  Look for exception in the container logs around the time the failure was reported.
   -  For instance below entries are for Application that was submitted on Fri Jul 6 16:26:35 -0400 2018 and also states finished successfully @ Fri Jul 6 18:39:33 -0400 2018
   -  Started looking for Errors / Exceptions from the YARN logs around the issue issue happened, found following entries in  Container: container_e12_1330511445220_0529_01_000002 logs. 

```
18/07/06 22:39:35 ERROR CoarseGrainedExecutorBackend: Executor self-exiting due to : Driver 10.115.52.184:43941 disassociated! Shutting down
```
*    when Spark driver fails, Driver disassociates from YARN Application Master.
*    Next steps are to identify the cause for the failure.

4.    Check ```--deploy-mode``` parameter to confirm if the spark application is submitted using cluster mode.
- When Spark application in launched in client mode, driver is spawned on the active headnode.  If there is any resource depletion on the headnode this would also affect the driver. It is recommended launch application in **cluster** Mode for production clusters.  
- If multiple applications are launched in client mode,  drivers will be spawned on the headnode sharing the resources with other critical services.  
5.    Make sure there was no network issue around the time failure happened. 
- Try increasing the spark.network.timeout from default value 120s which is a good number. At times with high CPU utilization the response from the containers could be delayed.
