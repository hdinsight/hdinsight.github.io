---
title: Azure HDInsight Solutions | Jupyter| Jupyter start-up Issues
description: Learn how to resolve <scenario>
services: hdinsight
author: csunilkumar
ms.author: sunilkc
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: 06/10/2019 (mm/dd/yyyy)
---

# Azure HDInsight Solutions | Jupyter | Jupyter start-up Issues.

## Scenario: Jupyter failes to start or in some cases When Jupiter is started from Ambari it starts and immediately (~1 minutes) gets back to the stopped state.

## Troubleshooting steps: 

First step in troubleshooting Jupyter startup issue is to checking jupyter logs stored under ```/var/log/jupyter``` on headnode0.
With Jupyter Highavailability introduced recently (June 2019), we might have to check jupyter logs on the active headnode.

## Issue: 
Analyzing the jupyter logs found following entry

```ConnectionError: HTTPConnectionPool(host='0.0.0.0', port=14000): Max retries exceeded with url: /webhdfs/v1/HdiNotebooks/?op=GETFILESTATUS&user.name=httpfs (Caused by NewConnectionError('<requests.packages.urllib3.connection.HTTPConnection object at 0x7f58abdcb950>: Failed to establish a new connection: [Errno 111] Connection refused',))```
- Notice the webhdfs in the log message, cluster configured to use wasb doesn't depend on hadoop-httpfs.
- Jupyter depends on a systemd service called "hadoop-httpfs" on ADLS, ADLS Gen 2 or WASBs  based clusters, 

## Cause:

- Check the value set for defaultfs in core-site.xml file.
- In this case value for defaultfs was changed from *wasb* to *wasbs* after the cluster had successfully created.
- Look up for jupyter ```start``` and ```configure``` definition under ```/var/lib/ambari-server/resources/common-services/JUPYTER/1.0.0/package/scripts/jupyter.py```.
- ```configure``` gets called when jupyter is configured on cluster configuration, that gets called on cluster creation.
- ```Start``` definition gets called on jupyter service start up. 
    This is where it was failing as the cluster was not initially configured to use WASBs and now the code path under use_httpfs was getting called and failing with above error.
    
## Solution
Change the value for defaultfs in core-site.xml to the original setting, in this case wasb://container@storagename.blob.core.windows.net
    
