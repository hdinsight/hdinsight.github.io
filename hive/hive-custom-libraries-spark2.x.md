---
title: How do I add custom Hive libraries for Spark 2.x clusters? | Microsoft Docs
description: Use the Hive FAQ for answers to common questions on Hive on Azure HDInsight platform.
keywords: Azure HDInsight, Hive, FAQ, troubleshooting guide, export metastore, import metastore
services: Azure HDInsight
documentationcenter: na
author: sasubha
manager: ''
editor: ''

ms.assetid: 921f8ed0-7327-4f5a-8a83-44e4a24bdd75
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 07/27/2018
ms.author: sasubha

---

### How do I add custom Hive libraries for Spark 2.x clusters?

#### Issue:

I followed the instructions from https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-add-hive-libraries to add custom hive libraries for my Spark2.x cluster but it is not working. I am unable to use my custom libraries.


#### Troubleshoot: 
The shell script at the above location was modified to use the updated Ambari scripts that are python scripts. Spark 2.x cluster still relies on the old Ambari shell scripts.

#### Resolution: 
1. ssh into the head node of the cluster

2. Download the old setup-customhivelibs script using: 

     `wget https://hdiconfigactions.blob.core.windows.net/linuxsetupcustomhivelibsv01/setup-customhivelibs-v00.sh`

3. Grant execute permissions to the script:

     `chmod +x setup-customhivelibs-v00.sh`

4. run the script like this:

     `sudo ./setup-customhivelibs-v00.sh wasb://<container with libraries>.<storage account>.blob.core.windows.net`

5. Allow some time for the service restarts to complete before proceeding. You can monitor the startup of the Hive service from the Ambari UI.
