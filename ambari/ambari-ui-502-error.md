---
title: Ambari UI 502 error | Microsoft Docs
description: Use the Ambari FAQ for answers to common questions on Ambari on Azure HDInsight platform.
keywords: Ambari, Azure HDInsight, FAQ, troubleshooting guide, common problems, accessing folder
services: Azure HDInsight
documentationcenter: na
author: shzhao
manager: ''
editor: ''

ms.assetid: 
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 03/14/2018
ms.author: shzhao
---

### Ambari UI 502 error

#### Issue
When you try to access Ambari UI of your HDInsight cluster: https://xxx.azurehdinsight.net, you get a message saying "502 - Web server received an invalid response whiule acting as a gateway or proxy server."

#### Root causes
In general, the HTTP 502 status code means that Ambari server is not running correctly on the active headnode. There are a few possible root causes:

##### 1) Ambari server failed to start
You can check ambari-server logs to find out why Ambari server failed to start. One of the common reason is database consistency check error. You can find this out in this log file:
~~~~
/var/log/ambari-server/ambari-server-check-database.log
~~~~

If you made any modifications to the cluster node, please undo them. You should always use Ambari UI to modify any Hadoop/Spark related configurations.

##### 2) Ambari server taking 100% CPU utilization
In rare situations, we've seen ambari-server process has close to 100% CPU utilization constantly. As a mitigation, you can ssh to the active headnode (take a look at the other article "How is Ambari used in HDInsight?"), kill the Ambari server process and start it again.
~~~~
ps -ef | grep AmbariServer
top -p <ambari-server-pid>
kill -9 <ambari-server-pid>
service ambari-server start
~~~~

##### 3) Ambari server killed by oom-killer
In some scenario your headnode runs out of memory, and the Linux oom-killer starts to pick processes to kill. You can verify this situation by searching the AmbariServer process ID, which should not be found. Then look at your /var/log/syslog, and look for something like this:
~~~~
Jul 27 15:29:30 hn0-xxxxxx kernel: [874192.703153] java invoked oom-killer: gfp_mask=0x23201ca, order=0, oom_score_adj=0
~~~~

You can identify which processes are taking memories and try to further root cause. 

##### 4) Other issues with Ambari server
Very rarely the Ambari server cannot handle the incoming request, you can find more info by looking at the ambari-server logs for any error. One such case is an error like this:
~~~~
Error Processing URI: /api/v1/clusters/xxxxxx/host_components - (java.lang.OutOfMemoryError) Java heap space
~~~~

#### Mitigation and fix
Most of the cases, to mitigate the problem, you can restart the active headnode. Or choose a larger VM size for your headnode. To report bugs or get help you can contact our HDInsight support team.
