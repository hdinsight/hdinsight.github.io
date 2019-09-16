---
title: Cannot create directory alert
description: Learn how to resolve
services: hdinsight
author: Marshall
ms.author:zhaya
ms.service: hdinsight
ms.custom: mitigation
ms.topic: Ambari Alert
ms.date: 09/16/2019
---

## Issue:
### 1. Alert message from Ambari: 
i.e.

1/1 local-dirs have errors:  [ /mnt/resource/hadoop/yarn/local : Cannot create directory: /mnt/resource/hadoop/yarn/local ] 1/1 log-dirs have errors:  [ /mnt/resource/hadoop/yarn/log : Cannot create directory: /mnt/resource/hadoop/yarn/log ] 
### 2. SSH to cluster:
the directories from Ambari alert is missing on affected worker node(s).

## Impact:
* Affected worker node(s) would still be used to run jobs. 
* However, from ambari portal, you would see these nodes are not recognized as running nodes from ambari metrics.
* Also, affected worker node(s) won't generate logs under missing directories. 

## Mitigation
manually created missing direcotries on the affected worker node(s).
* ssh to affected node
* get root user. $ sudo su
* recursively create needed directories.
* change owner and group for these folders.
```
$ chown -R yarn /mnt/resource/hadoop/yarn/local
$ chgrp -R hadoop /mnt/resource/hadoop/yarn/local
$ chown -R yarn /mnt/resource/hadoop/yarn/log
$ chgrp -R hadoop /mnt/resource/hadoop/yarn/log
```
* go back to ambari portal. click on this alert. disable and enable the alert. (reset the alert status, usually it takes 5 mins to update)
