---
title: Cannot login to Zeppelin after changing the ADDS password in active directory? | Microsoft Docs
description: Use the Zeppelin FAQ for answers to common questions on Zeppelin on Azure HDInsight platform.
keywords: Azure HDInsight, Zeppelin, FAQ, troubleshooting guide, 
services: Azure HDInsight
documentationcenter: na
author: 
manager: ''
editor: ''


ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 01/17/2018
ms.author: jyotima
---

### TSG Zeppelin Cannot Login 
#### Issue
Cannot login to Zeppelin after changing the ADDS password in active directory.

#### Symptoms
- The user mentioned in the ```activeDirectoryRealm.systemUsername``` of the ```shiro_ini``` file changed the active directory password. 
- Only the user mentioned in the shiro file is able to login to zeppelin.
- No other domain joined user can login to zeppelin.


#### Resolution Steps
1.	Verify that the changed password is the root cause by including ```activeDirectoryRealm.systemUsername = <new password>``` in the zeppelin shiro_ini config in ambari. Remove the ```activeDirectoryRealm.hadoopSecurityCredentialPath``` setting. Below is where we can find it.
   ![Shiro](shiro.png)
    
2.	If users can now login to zeppelin after step 1, create a new jceks file with the new password and replace the ```activeDirectoryRealm.hadoopSecurityCredentialPath``` with the new file.