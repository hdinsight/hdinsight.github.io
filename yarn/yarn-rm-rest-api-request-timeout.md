---
title: TSG Yarn RM REST API Request Timeout | Microsoft Docs
description: How to investigate Yarn RM REST API request timeout.
keywords: Azure HDInsight, Yarn, FAQ, troubleshooting guide, download logs
services: Azure HDInsight
documentationcenter: na
author: shzhao
manager: ''
editor: ''

ms.assetid: C5A5726E-FFF9-4167-80DE-45B4D46B54E2
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 10/31/2017
ms.author: shzhao

---

### TSG Yarn RM REST API Request Timeout

#### Issue:

Access to Yarn RM REST API results in Timeout. You'll see alert in YARN service in Ambari. Yarn Resource Manager UI cannot be opened.

#### Resolution Steps: 

1) Basic check of the system. Use Linux command "top", "free", and "df" to check if CPU/Memory/Disk are sufficient on the system.

2) Look at Yarn Resource Manager log to vind if there are obvious Exception correlates to this problem.

3) Manually reproduce the problem by trying to connect to Yarn RM REST server:
~~~
curl http://localhost:8088
~~~

4) If the above request results in hang or connection timeout. And no logs in Yarn RM log. Examine TCP connections of the RM process.
Find the ResourceManager process ID by:
~~~
ps -ef | grep yarn
~~~

Then list all TCP connections:
~~~
sudo lsof -p 37293 | grep "TCP"
~~~

Found a bunch of connections (250 of them) like this:
~~~
java    37293 yarn 1013u     IPv6          835743737      0t0       TCP 10.0.0.11:53521->10.0.0.15:38696 (ESTABLISHED)
~~~

Port 38696 on 10.0.0.15 is actually ApplicationMaster running on wn0. And manually trying to connect to 10.0.0.15:38696 results in time out. This is probably caused RM REST server hang.

5) Example the running ApplicationMaster:
Now list all running Yarn applications:
~~~
yarn application -list
~~~

Find AM container logs by SSH to the coresponding worker node, and navigate to folder:
~~~
/mnt/resource/hadoop/yarn/log/application_1505714902721_0088
~~~

In our case we found that the application is a Spark Streaming application and judging from the AM logs it is hang since a while ago, because it is using an outdated SparkEventHubsConnector (https://github.com/Azure/spark-eventhubs) which can cause deadlock in some circumstances.

6) Now why does a hang Spark Streaming job can cause RM Rest API server hang? This is the root cause:
The root cause of this problem is that Yarn RM process exhausted threads in QueueThreadPool (defaults to 250). This is because previous WebProxy connections to a running Spark Streaming AM UI port are hung (250 of them). This is caused by user's spark streaming application using probably an outdated SparkEventHubsConnector, which deadlocked and hang holding an lock that StreamingJobProgressListener is waiting on.


#### Solution
1) Kill the hang Yarn application from any headnode:
~~~
yarn application -kill application_1505714902721_0088
~~~

2) Update Spark Streaming EventHubs library and resubmit the Spark Streaming application.