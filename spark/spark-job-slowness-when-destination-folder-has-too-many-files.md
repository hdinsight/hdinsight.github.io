---
title: Spark job becomes slow when the destination folder has too many files | Microsoft Docs
description: 
keywords: Azure HDInsight, Spark, FAQ, troubleshooting guide, common problems, remote submission
services: Azure HDInsight
documentationcenter: na
author: shzhao
manager: ''
editor: ''
---

#### Issue:
Spark job becomes slow when the destination folder has too many files

#### Scenario:
When running in HDInsight cluster, the Spark job that writes to Azure storage container becomes slow when there are many files/subfolders. For examplke, it takes 20 seconds when writting to a new container, but about 2 minutes when writting to a container that has 200k files.

#### Root cause:
This is a Spark issue. The slowness comes from ListBlob and GetBlobProperties operation during Spark job execution.

When you create a partitioned table, the most important information is what the partitions are. Only with this information, you can reduce the cost when scan the table

To maintain this information, Spark has to maintain a FileStatusCache which contains info about directory structure. With this information, Spark can parse the paths and be aware of the available partitions. As the benefit, Spark only touches the interested ones when you read data. Straightforwardly, to make this information up-to-date, when you write new data, Spark has to list all files under the directory to update this cache.

In Spark 1.6, every time you update the directory, you (1) clear the cache (2) recursively list all files and (3) update the whole cache. This will lead to a bunch of listing operations.

In Spark 2.1, while we do not need to update the cache after every write, Spark will check whether existing partition column matches with the proposed one in the current write request, so it will also lead to listing operations at the beginning of every write.

In Spark 2.2, when writing data with append mode, this performance problem should be fixed.
 
#### Workaround:
For every Nth micro batch where N % 100 == 0 (100 is just an example), move existing data to another directory which can be loaded by Hive.

By controlling the overall size of the directory being directly written by Spark, the list operations can be faster 

