---
title: Jupyter server 404 Not Found error due to Blocking Cross Origion API | Microsoft Docs
description: Use the Spark FAQ for answers to common questions on Spark on Azure HDInsight platform.
keywords: Azure HDInsight, jupyter, troubleshooting guide, common problems, remote submission
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
ms.date: 01/18/2017
ms.author: sunilkc
---

### Symptoms
When access Jupyter, the UI pops up an error box saying "Not Found".

When checking Jupyter logs, you will see something like this:
~~~
[W 2018-08-21 17:43:33.352 NotebookApp] 404 PUT /api/contents/PySpark/05%20-%20Spark%20Machine%20Learning%20-%20Predictive%20analysis%20on%20food%20inspection%20data%20using%20MLLib.ipynb (10.16.0.144) 4504.03ms referer=https://pnhr01hdi-corpdir.msappproxy.net/jupyter/notebooks/PySpark/05%20-%20Spark%20Machine%20Learning%20-%20Predictive%20analysis%20on%20food%20inspection%20data%20using%20MLLib.ipynb
Blocking Cross Origin API request.  Origin: https://xxx.xxx.xxx, Host: hn0-pnhr01.j101qxjrl4zebmhb0vmhg044xe.ax.internal.cloudapp.net:8001
~~~

Sometimes you see IP address in "Origin" field in the above logs.

### Scenarios
There are a few scenarios that can cause this problem:

1. If you have configured NSG Rules to restricts access to the cluster. While you can directly access Ambari and other services using IP address rather than the Cluster Name. You might start getting 404 "Not Found"when accessing Jupyter.

2. If you have given your HDInsight gateway a customized DNS name other than the starndard xxx.azurehdinsight.net.

### Troubleshooting steps
1. SSH into the cluster headnode run this command "ps ax | grep jupyter"  to list all the entries for jupyter.

This should be the output of the command, if it differs, jupyter might not be starting correctly. You may restart Jupyter server or reboot headnode0.
~~~~
ps ax | grep jupyter
 10384 ?        S      0:00 sudo -u spark PATH=/usr/bin/anaconda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/var/lib/ambari-agent stdbuf -oL -eL /usr/bin/anaconda/bin/jupyter-notebook --config=/var/lib/.jupyter/jupyter_notebook_config.py --NotebookApp.allow_origin="https://kcsparkhdi.azurehdinsight.net"
 10387 ?        Sl     5:32 /usr/bin/anaconda/bin/python /usr/bin/anaconda/bin/jupyter-notebook --config=/var/lib/.jupyter/jupyter_notebook_config.py --NotebookApp.allow_origin="https://kcsparkhdi.azurehdinsight.net"
 10429 ?        Ss     0:06 /usr/bin/python /var/lib/.jupyter/jupyter_logger.py
 43735 pts/0    S+     0:00 vi /var/lib/ambari-agent/cache/common-services/JUPYTER/1.0.0/package/scripts/jupyter.py
~~~~

### Root cause

Refer this link for more details on "NotebookApp.allow_origin " http://jupyter-notebook.readthedocs.io/en/stable/config.html

On HDInsight spark clusters we are restricting access to Jupyter using the FQDN and to get this working using IP address change the following two files.

### Solution
1. Please modify the jupyter.py files in these two places:

~~~~
	/var/lib/ambari-server/resources/common-services/JUPYTER/1.0.0/package/scripts/jupyter.py
	/var/lib/ambari-agent/cache/common-services/JUPYTER/1.0.0/package/scripts/jupyter.py
~~~~

On the line that says:
~~~~ 
    NotebookApp.allow_origin='\"https://{2}.{3}\"' 
~~~~

Change this to 
~~~~ 
    NotebookApp.allow_origin='\"*\"' 
~~~~

2. Restart the Jupyter service from Ambari.

3. After that, ps aux | grep jupyter should show that it allows for any URL to connect to it.

### Disclaimer
**Do note that this is less secure than the setting we already had in place. But it is assumed access to the clsuter is restricted and that one from outside is allowed to connect to the cluster as we have NSG in place.**
