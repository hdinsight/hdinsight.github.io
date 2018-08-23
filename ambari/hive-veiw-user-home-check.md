---
title: Hive View when accessed from Ambari UI fails on "User HOME check" | Microsoft Docs
description: Use the Ambari FAQ for answers to common questions on Ambari on Azure HDInsight platform.
keywords: Hive, View, Ambari, Azure HDInsight, FAQ, troubleshooting guide, common problems, accessing folder
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
ms.date: 08/23/2018
ms.author: Sunilkc
---

## Issue
Unable to open Hive view from Ambari UI, User HOME check fails with error "File/Folder does not exist". Issue was prominently observed on latest HDInsight Cluster, ```HDIVersion : 3.6.1000.65.1807162004```

### Steps to Reproduce
On any of HDinsight cluster(Hadoop, llap , Spark), Open Hive view from Ambari UI. Access Hive View using link "https://{clustername}.azurehdinsight.net/#/main/view/HIVE/auto_hive20_instance" and the 
 "User HOME check" will fail with following error message.  
``` Message: File/Folder does not exist: /user/admin [737c9e89-8324-4202-ae64-b69fd7da6b23][2018-07-23T10:42:56.9329924-07:00] [ServerRequestId:737c9e89-8324-4202-ae64-b69fd7da6b23 ```

### Mitigation
Creating that missing folder would pass the ``` User HOME check ```, that would open Hive View successfully.  

Created a folder "admin" under cluster root folder mitigates the issue, as shown in the error message.
Example Path:  on a ADL name "eastusadl" , default root is  "/clusters/{clustername}" and folder needs to be created missing under "/user"
