---
title: General Spark Peformance Troubleshootinng Guidance | Microsoft Docs
description: Use the Spark FAQ for answers to common questions on Spark on Azure HDInsight platform.
keywords: Azure HDInsight, FAQ, troubleshooting guide, common problems, remote submission
services: Azure HDInsight
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
ms.date: 03/01/2018
ms.author: sunilkc
---
# Azure HDInsight Solutions | Spark | Application Failure Probing Questions

* Was this application working fine? 
     * If application was working fine then check what changed between working and non-working scenario?_
* _How are the Spark application submitted to the HDInsight? 
     * Spark applications can be submitted using notebooks (Juptyer/Zeppelin)/ using ODBC clients that gets connected to Spark Thrift Server/ directly on from Headnode using Spark-Shell)_ 
     * if Application is submitted using notebooks then is it a batch or interactive session?_ 
* _Is this a Spark SQL / Spark Steaming  or Just a batch job?_ 

## Minimum data required to better understand any Spark Application performance or Spark Application failure issues.

Spark Applications are usually submitting to HDInsight clusters from Azure Data Factory, Jupyter, Zeppelin, JDBC, SSH or Livy directly using curl command.

| Front End     | Servied Used on HDInsight  |
| ------------- |:--------------------------:| 
| Jupyter       | Livy                       |
| ADF           | Livy                       |
| Zeppelin      | Interpreter(Livy, Spark)   |
| Curl          | Livy                       |

## Details required to start troubleshooting following Spark Application issues 
    *   Slow Performance : Spark application takes more time compared to another HDInsight cluster, still complete successfully.
    *   Unexpected Failure: Spark Application starts processing data but fails to complete with some exception
    *   Application fails with Exception :Spark Application starts processing data but fails to complete with some exception
    *   Application hangs-Never gets into finished state 
    *   Spark application fails to start when submitted from Spark-CLI

1. Spark application submission if initiated from Azure Data Factory / Jupyter  or any other client application like curl that uses livy, then follow the steps below.  
    *   Confirm livy server is started on HN0 from Ambari UI, incase it is stopped start the service.  
    *   In case livy server is not starting, and you see ``` java.lang.OutOfMemoryError: unable to create new native thread ``` in livy logs ``` /var/log/livy/livy-livy-server.out ``` then follow steps detailed in  [livy-nativethread-exhaustion](livy-nativethread-exhaustion.md).  
    * If exception metioned in Point b. was not found then Capture the livy logs from the cluster ( ``` /var/log/livy/livy-livy-server.out ```), 
    * Get Jupyter logs (``` /var/log/jupyter/ ```) when troubleshooting Spark Application issues that were submitted using jupter notebook.  
        * Jupyter uses livy to submit Spark application, get Livy logs as well.

2. If application is submitted using JDBC that uses Spark Thrift Service then get Spark Thrift Driver logs from ``` /var/log/spark/sparkthriftdriver.log ```  

3. In case the Spark job is submitted from spark-shell then get the complete spark-submit command.

4. For any spark application performance issues (including the three scenarios list above) first note the Application ID, next capture YARN logs for the application that is experiencing performance issue (Slow/Hang) or failures.
        a. [How do I download Yarn logs from HDInsight cluster?](/yarn/yarn-download-logs.html), this article details different options to capture YARN Logs.
        b. Download all Application Master logs.
        c. Get logs for all containers (Driver and Executor).

5. Get screenshot of YARN UI showing the start datetime, end datetime and the status for the failed application.

6. If this application had completed successful early then capture start, end datetime, application status and also the YARN logs for this successfully completed Spark Application [How do I download Yarn logs from HDInsight cluster?](/yarn/yarn-download-logs.html). 

For General Spark Tuning [Refer](https://spark.apache.org/docs/latest/tuning.html)
