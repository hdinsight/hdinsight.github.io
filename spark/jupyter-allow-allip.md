---
title: How to allow jupyter to listen on all IP address when part of VNet with NSG Rule in place | Microsoft Docs
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

#### While creating HDInsight cluster part of VNets configured with Network Security Group provides control on accessing who can and how they can access the cluster,but at times it blocks access to required URLs.
#### One such URL is access to jupyter notebooks.

### Scenario
If you have configured NSG Rules to restricts access to the cluster. While you can directly access Ambari and other services using IP address rather than the Cluster Name. You might start getting 404 "Not Found"when accessing Jupyter.

An error occurred while creating new notebook. "Not Found".

### Troubleshooting steps
1. Login into the cluster headnode run this command "ps ax | grep jupyter"  to list all the entries for jupyter.

~~~~
ps ax | grep jupyter
 10384 ?        S      0:00 sudo -u spark PATH=/usr/bin/anaconda/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/var/lib/ambari-agent stdbuf -oL -eL /usr/bin/anaconda/bin/jupyter-notebook --config=/var/lib/.jupyter/jupyter_notebook_config.py --NotebookApp.allow_origin="https://kcsparkhdi.azurehdinsight.net"
 10387 ?        Sl     5:32 /usr/bin/anaconda/bin/python /usr/bin/anaconda/bin/jupyter-notebook --config=/var/lib/.jupyter/jupyter_notebook_config.py --NotebookApp.allow_origin="https://kcsparkhdi.azurehdinsight.net"
 10429 ?        Ss     0:06 /usr/bin/python /var/lib/.jupyter/jupyter_logger.py
 43735 pts/0    S+     0:00 vi /var/lib/ambari-agent/cache/common-services/JUPYTER/1.0.0/package/scripts/jupyter.py
~~~~

### Refer this link for more details on "NotebookApp.allow_origin " http://jupyter-notebook.readthedocs.io/en/stable/config.html
### On HDInsight spark clusters we are restricting access to Jupyter using the FQDN and to get this working using IP address change the following two files.

2. Please modify the jupyter.py files in these two places:

~~~~
	/var/lib/ambari-server/resources/common-services/JUPYTER/1.0.0/package/scripts/jupyter.py
	/var/lib/ambari-agent/cache/common-services/JUPYTER/1.0.0/package/scripts/jupyter.py
~~~~

2.1 On the line that says:
~~~~ 
    NotebookApp.allow_origin='\"https://{2}.{3}\"' 
~~~~

2.2 Change this to 
~~~~ 
    NotebookApp.allow_origin='\"*\"' 
~~~~

3. Restart the Jupyter service from Ambari.

4. After that, ps aux | grep jupyter should show that it allows for any URL to connect to it.

##### Do note that this is less secure than the setting we already had in place. But it is assumed access to the clsuter is restricted and that one from outside is allowed to connect to the cluster as we have NSG in place.
