---
title: Troubleshooting "InvalidInputException" in Hive | Microsoft Docs
description: Use the Spark FAQ for answers to common questions on Spark on Azure HDInsight platform.
keywords: Azure HDInsight, livy, jupyter, troubleshooting guide, common problems, remote submission
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
ms.date: 08/30/2017
ms.author: sunilkc
---

### Scenario: 
Hive Script that uses dynamic partitions to load data. Job completed successfully but in the stderr output we see that one tenant has 137 rows but no data files. When the table was read this raised exception.

### Error : 
Vertex failed, vertexName=Map 1, vertexId=vertex_1501080280391_95286_2_00, diagnostics=[Vertex vertex_1501080280391_95286_2_00 [Map 1] killed/failed due to:ROOT_INPUT_INIT_FAILURE, Vertex Input: s initializer failed, vertex=vertex_1501080280391_95286_2_00 [Map 1], org.apache.hadoop.mapred.InvalidInputException: Input path does not exist: wasb://<container>@<storage>.blob.core.windows.net/ReportingData/DailyChanged/date=2017-08-23/tenant=2a6y07ed-de2d-40f2-9e16-3g4j6319kl18/changeddate=2017-08-24T12_56_48

### Troubleshooting Steps:

#### Makes sure the folder exists by executing.
~~~~ 
hdfs dfs -ls <path> 
~~~~

If the path exists, execute simple command to confirm the data could be fetched.
select * from TABLE ConferenceDailyChanged where ChangedDate = <date> limit 100

Once you confirm a simple query executes successfully, proceed to check the data format.
If the data is stored in JSON, XML, Parquet