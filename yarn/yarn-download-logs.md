---
title: How do I download Yarn logs from HDInsight cluster? | Microsoft Docs
description: Use the Yarn FAQ for answers to common questions on Yarn on Azure HDInsight platform.
keywords: Azure HDInsight, Yarn, FAQ, troubleshooting guide, download logs
services: Azure HDInsight
documentationcenter: na
author: dkakadia
manager: ''
editor: ''

ms.assetid: C5A5726E-FFF9-4167-80DE-45B4D46B54E2
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 04/07/2017
ms.author: dkakadia

---

### How do I download Yarn logs from HDInsight cluster?

#### Issue:

Need to download Yarn application master and other container logs from HDInsight cluster.  

#### Resolution Steps: 

1) Connect to the HDInsight cluster with an Secure Shell (SSH) client (check Further Reading section below).

2) List all the application ids of the currently running Yarn applications with the following command:

~~~
yarn top
~~~

Note the application id from the `APPLICATIONID` column whose logs are to be downloaded.

~~~
YARN top - 18:00:07, up 19d, 0:14, 0 active users, queue(s): root
NodeManager(s): 4 total, 4 active, 0 unhealthy, 0 decommissioned, 0 lost, 0 rebooted
Queue(s) Applications: 2 running, 10 submitted, 0 pending, 8 completed, 0 killed, 0 failed
Queue(s) Mem(GB): 97 available, 3 allocated, 0 pending, 0 reserved
Queue(s) VCores: 58 available, 2 allocated, 0 pending, 0 reserved
Queue(s) Containers: 2 allocated, 0 pending, 0 reserved

                  APPLICATIONID USER             TYPE      QUEUE   #CONT  #RCONT  VCORES RVCORES     MEM    RMEM  VCORESECS    MEMSECS %PROGR       TIME NAME
 application_1490377567345_0007 hive            spark  thriftsvr       1       0       1       0      1G      0G    1628407    2442611  10.00   18:20:20 Thrift JDBC/ODBC Server
 application_1490377567345_0006 hive            spark  thriftsvr       1       0       1       0      1G      0G    1628430    2442645  10.00   18:20:20 Thrift JDBC/ODBC Server
~~~

3) Download Yarn containers logs for all application masters with the following command:
   
~~~
yarn logs -applicationId <application_id> -am ALL > amlogs.txt
~~~

This will create the log file named `amlogs.txt` in text format. 

4) Download Yarn container logs for only the latest application master with the following command:

~~~
yarn logs -applicationId <application_id> -am -1 > latestamlogs.txt
~~~

This will create the log file named `latestamlogs.txt` in text format. 

5) Download YARN container logs for first two application masters with the following command:

~~~
yarn logs -applicationId <application_id> -am 1,2 > first2amlogs.txt 
~~~

This will create the log file named `first2amlogs.txt` in text format. 

6) Download all Yarn container logs with the following command:

~~~
yarn logs -applicationId <application_id> > logs.txt
~~~

This will create the log file named `logs.txt` in text format. 

7) Download yarn container log for a particular container with the following command:

~~~
yarn logs -applicationId <application_id> -containerId <container_id> > containerlogs.txt 
~~~

This will create the log file named `containerlogs.txt` in text format.

#### Further Readings:

1) [Connect to HDInsight Cluster using SSH](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-linux-use-ssh-unix)

2) [Apache Hadoop Yarn concepts and applications](https://hortonworks.com/blog/apache-hadoop-yarn-concepts-and-applications/)