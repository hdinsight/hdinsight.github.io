---
title: Why do I see 'permission denied' when attempting to create a table in Secure Hive? | Microsoft Docs
description: Use the Hive FAQ for answers to common questions on Hive on Azure HDInsight platform.
keywords: Azure HDInsight, ambari, Tez, FAQ, troubleshooting guide, 
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
ms.author: msft-tacox
---

### Why do I get a permission denied error when trying to create a Hive table in ESP?
#### Issue
The ability to create a table in Hive is decided by the permissions applied to the cluster's storage account. If the cluster storage account permissions are incorrect, you will not be able to create tables. This means that you could have the correct Ranger policies for table creation, and still see "Permission Denied" errors.

#### Symptoms
You will see the following error when attempting to create a table:
```
java.sql.SQLException: Error while compiling statement: FAILED: HiveAccessControlException Permission denied: user [hdiuser] does not have [ALL] privilege on [wasbs://data@xxxxx.blob.core.windows.net/path/table]
```

If you run the following HDFS storage command:
```
hdfs dfs -mkdir wasbs://data@xxxxx.blob.core.windows.net/path/table
```
You will see a similar error message.

This is caused by a lack of sufficient permissions on the storage container being used. The user creating the Hive table needs read, write and execute permissions against the container. For more information, please see https://hortonworks.com/blog/best-practices-for-hive-authorization-using-apache-ranger-in-hdp-2-2/

