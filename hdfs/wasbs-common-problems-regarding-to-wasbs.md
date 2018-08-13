---
title: Common problems regarding to WASBS | Microsoft Docs
description: Common problems regarding to WASBS
keywords: Azure HDInsight, HDFS, WASB, FAQ, troubleshooting guide, common problems
services: Azure HDInsight
author: shzhao
---

## Enable WASBS in HDInsight clusters
WASBS is the hdfs schema to access secure transfer enabled Azure Storage account. The supported way to enable WASBS is to first create a storage account with secure transfer enabled flag, then use it to create an HDInsight cluster. This is the detailed steps:
https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-create-linux-clusters-with-secure-transfer-storage

## Common problems regarding to WASBS

### StorageException: The account being accessed does not support http

#### Symptoms reported by customer
Customer reports that a Livy job failed with message:
~~~
Exception in thread "main" org.apache.hadoop.fs.azure.AzureException: com.microsoft.azure.storage.StorageException: The account being accessed does not support http.
~~~

The Livy job was submitted using this curl command (as can be seen it use wasbs to access files):
~~~
curl -X POST \
  https://<clustername>.azurehdinsight.net/livy/batches \
  -H 'Authorization: Basic <REDACTED>' \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -H 'Postman-Token: <REDACTED>' \
  -d '{
    "file":"wasbs://<container>@<storageaccount>.blob.core.windows.net/smoothing/smoothing.jar",
    "className":"SparkApplication",
    "name": "Smoothing",
    "executorMemory":"1G",
    "numExecutors": 2,
    "executorCores": 2,
    "files": ["wasbs://<container>@<storageaccount>.blob.core.windows.net/smoothing/qa.conf", 
    "wasbs://<container>@<storageaccount>.blob.core.windows.net/smoothing/log4j.properties"],
    "args": ["-conf","qa.conf"],
    "conf": {"spark.driver.extraJavaOptions":"-Dlog4j.configuration=log4j.properties"}
}'
~~~

#### Investigation steps
1. Ask how they create the cluster. If they create the cluster first (using a storage account without secure transfer enabled), then manually turn on secure transfer in the primary/additional storage account, this is most likely the reason to cause the StorageException. The reason is because there are many cluster configurations still using wasb:// instead of wasbs://, which causes the StorageException.

2. Make sure the WASBS schema work correctly. In an SSH session, try:
~~~
hadoop fs -ls wasbs:///
~~~
If it works correctly, this indicates that the WASB driver works correctly. Otherwise please notify product team about this bug.

#### Mitigation
Most often, for customers who want to use WASBS we should ask them to follow the documentation to create a cluster with secure transfer enabled storage account to begin with.