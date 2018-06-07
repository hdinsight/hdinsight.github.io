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

##### Probing Questions ####

* _Was this application working fine? If application was working fine then check what changed between working and non-working scenario?_
* _How are you submitting the Spark Job? (notebooks/Spark Thrift Server/Spark-Shell)_ 
* _If Application is submitted using notebooks then is it a batch or interactive session?_ 
* _Is this a Spark SQL / Spark Steaming  or Just a batch job?_ 

#### Minimum data needed to better understand and start troubleshooting any Spark Application performance or Spark Application failure issues.

Spark Applications are usually submitting to HDInsight clusters from Azure Data Factory, Jupyter, Zeppelin, JDBC, SSH or Livy directly using curl command.

| Front End     | Servied Used on HDInsight  |
| ------------- |:--------------------------:| 
| Jupyter       | Livy                       |
| ADF           | Livy                       |
| Zeppelin      | Interpreter(Livy, Spark)   |


##### Here are the details that you need to capture to troubleshoot Spark Application issues (Slow Performance, Unexpected Failure, Exception or Application hang-Never gets into finished state). #####

1. Spark application uses livy to submit to spark, when application submission is initiated from ADF or any other client application like curl in that case follow the steps below.  
a. Confirm livy server is started on HN0 from Ambari UI, incase it is stopped start the service.  
b. In case livy server is not starting, and you see ``` java.lang.OutOfMemoryError: unable to create new native thread ``` in livy logs ``` /var/log/livy/livy-livy-server.out ``` then follow steps detailed in  [livy-nativethread-exhaustion](livy-nativethread-exhaustion.md).  
   c. Capture the livy logs from the cluster ( ``` /var/log/livy/livy-livy-server.out ```), If exception metioned in Point b. was not found.
   d. Get Jupyter logs (``` /var/log/jupyter/ ```) when troubleshooting Spark Application issues that were submitted using jupter notebook.  
   * Jupyter uses livy to submit Spark application so get Livy logs as well

2. If application is submitted using JDBC that uses Spark Thrift Service then get Spark Thrift Driver logs from ``` /var/log/spark/sparkthriftdriver.log ```  
3. In case the Spark job is submitted from spark-shell then get the complete spark-submit command.

4. For any spark application performance issues (including the three scenarios list above) first note the Application ID, next capture YARN logs for the application that is experiencing performance issue (Slow/Hang) or failures.
        a. [How do I download Yarn logs from HDInsight cluster?](yarn-download-logs.md), this article details different options to capture YARN Logs.
        b. Download all Application Master logs.
        c. And also get logs for all containers (Driver and Executor).

5. Get screenshot of YARN UI showing the start datetime, end datetime and the status for the failed application.

6. If this application had completed successful  early then capture start, end datetime, application status and also the YARN logs for this successfully completed Spark Application [How do I download Yarn logs from HDInsight cluster?](yarn-download-logs.md). 
