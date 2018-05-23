---
title: General Spark Peformance Troubelshootinng Guidance | Microsoft Docs
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

When did the issue started happening?
What this application working fine? If application was working fine then check what changed between working and non-working scenario ?
How are you submitting the Spark Job? (notebooks/Spark Thrift Server/Spark-Shell)
If Application is submitted using notebooks then is it a batch or interactive session?
IS this a Spark SQL / Spark Steaming  or Just a batch job?

#### Minimum data needed to better understand and start troubleshooting any Spark Application performance or Spark Application failure issues.

Spark Applications are usually submitting to HDInsight clusters from Azure Data Factory, Jupyter, Zeppelin, JDBC, SSH or Livy directly using curl command.

| Front End     | Servied Used on HDInsight  |
| ------------- |:--------------------------:| 
| Jupyter       | Livy                       |
| ADF           | Livy                       |
| Zeppelin      | Interpreter(Livy, Spark)   |


Here are the details that you need to capture to troubleshoot Spark Application issues (Slow Performance, Unexpected Failure, Exception or Application hang-Never gets into finished state).

1. Application submission initiated from ADF or any other client application like curl submits the spark application via livy then follow the steps below.  
   a. Confirm livy server is started on HN0 from Ambari UI, incase it is stopped start the service.  
   b. In case livy server is not starting, and you see ``` java.lang.OutOfMemoryError: unable to create new native thread ``` in livy logs ``` /var/log/livy/livy-livy-server.out ``` then follow steps detailed in  [livy-nativethread-exhaustion](livy-nativethread-exhaustion.md).  
   c. Capture the livy logs from the cluster ( ``` /var/log/livy/livy-livy-server.out ```), If exception metioned in Point b. was not found.
  
2. Jupyter logs when troubleshooting Spark Application issues that were submitted using jupter notebook.
   Jupyter uses livy to submit Spark application so get Livy logs as well

3. If application is submitted using JDBC that uses Spark Thrift Service then get Spark Thrift Driver logs from ``` /var/log/spark/sparkthriftdriver.log ```

4. In case the Spark job is submitted from spark-shell then get the complete spark-submit command.

5. For any spark application performance issues, capture YARN logs for the application that is experiencing performance issue 
(Slow/Hang) or failures. Get logs for all containers (Driver and Executor).
        a. [How do I download Yarn logs from HDInsight cluster?](yarn-download-logs.md)

6.Share screenshot of YARN UI showing the start datetime, end datetime and the status for the failed application.

7. If this application had any successfull run early then capture start, end datetime, application status and also the YARN logs for the completed job [How do I download Yarn logs from HDInsight cluster?](yarn-download-logs.md). 

Please contact the Support Professional to upload the YARN Logs and also start time and end time for spark applications (Successful run and Failed instance)
