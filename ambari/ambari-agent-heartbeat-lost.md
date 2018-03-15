---
title: Ambari agent heartbeat lost issue | Microsoft Docs
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

### Ambari agent heartbeat lost issue

#### Issue
This is one of the common issues. User sees Ambari alerts in Ambari UI saying that for some nodes Ambari agent heatbeat lost.

#### Potential root cause

In general, this alert means Ambari agent on the target node does not send periodical heartbeat message to the right server. There are many possible root causes:

##### 1) Node is down
If you cannot ssh to the target node, it might be a serious issue preventing the node from starting up. You can wait for a while because it is possible that Azure is patching your node and it will become online soon.

##### 2) Ambari agent not started

Check if ambari-agent is running or not: 
~~~~
service ambari-agent status
~~~~

If not, check if failover controller services are running:
~~~~
ps -ef | grep failover
~~~~

If failover controller services are not running, it is likely due to a problem prevent hdinsight-agent from starting failover controller. Check hdinsight-agent log from "/var/log/hdinsight-agent/hdinsight-agent.out" file.

##### 3) Ambari agent has high percentage CPU utilization

Due to various ambari-agent bug, in rare cases, your ambari-agent can have high (close to 100) percentage CPU utilization. To check this, first use the following command to findout process ID of ambari-agent:
~~~~
ps -ef | grep ambari_agent
~~~~
Then run the following command to show CPU utilization:
~~~~
top -p <ambari-agent-pid>
~~~~

Try restarting ambari-agent usually can mitigate this problem:
~~~~
service ambari-agent restart
~~~~
If this does not work, then you can simply kill the ambari-agent process then start it up:
~~~~
kill -9 <ambari-agent-pid>
service ambari-agent start
~~~~

##### 4) Networking issue
Another common cause of heartbeat lost is due to networking issues. Sometimes user manually modified /etc/hosts or /etc/resolv.conf file, resulting in DNS resolution error so that the ambari-agent cannot send out heartbeat. Note that please don't ever manually modify any networking settings on your cluster node.

You'll see logs like this in your ambari-agent logs:
~~~~
Exception in thread Thread-3:
Traceback (most recent call last):
  File "/usr/lib/python2.7/threading.py", line 801, in __bootstrap_inner
    self.run()
  File "/usr/lib/python2.6/site-packages/ambari_agent/Controller.py", line 489, in run
    self.register = Register(self.config)
  File "/usr/lib/python2.6/site-packages/ambari_agent/Register.py", line 35, in __init__
    self.hardware = Hardware(self.config)
  File "/usr/lib/python2.6/site-packages/ambari_agent/Hardware.py", line 52, in __init__
    self.hardware.update(Facter(self.config).facterInfo())
  File "/usr/lib/python2.6/site-packages/ambari_agent/Facter.py", line 571, in facterInfo
    facterInfo = super(FacterLinux, self).facterInfo()
  File "/usr/lib/python2.6/site-packages/ambari_agent/Facter.py", line 248, in facterInfo
    'ipaddress': self.getIpAddress(),
  File "/usr/lib/python2.6/site-packages/ambari_agent/Facter.py", line 81, in getIpAddress
    return socket.gethostbyname(self.getFqdn().lower())
gaierror: [Errno -2] Name or service not known
~~~~

There are a few commands to help you debug the networking issue:
~~~~
hostname -f
~~~~

This should return your FQDN, something like "hn0-xxxx.zt4kvot42vuezoi2izzf1qvjsd.xx.internal.cloudapp.net". If this does not work, you might have modified some of the network configuration file, or your vNet settings or NSG rules, please fix them.

~~~~
ping headnodehost
~~~~

If this fails that means the ambari-agent cannot reach the headnode that ambari-server runs.

#### Mitigation and fix
Most of the case you can fix the issue by restarting ambari-agent service, rebooting the node ambari-agent runs on, or fixing any networking settings. If this problem happens often or non of these steps work, please contact HDInsight support team.
