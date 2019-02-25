---
title: Azure HDInsight Solutions | Apache Spark | Using Spark-Submit to create Apache Spark jobs
description: Learn how to use spark-submit to create Apache Spark jobs.
services: hdinsight
author: csunilkumar
ms.author: sunilkc
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: 11/9/2018
---

# Azure HDInsight Solutions | Apache Spark | Using Spark-Submit to create Apache Spark jobs

## Scenario: You would like to use the spark-submit shell script to create Apache Spark jobs, but the required parameters are unclear.

## Issue

For example, you would like to create a job that requires a class that is only available in a specific jar file (mssql-jdbc-6.2.2.jre8.jar). This jar file is not included in the default JDBC jar that is installed on the cluster.

## Solution

The three Parameters listed below are used to load an external jar file.

```config
spark.driver.extraClassPath
spark.yarn.user.classpath.first
spark.executor.extraClassPath
```

The following curl command submits a Spark application with additional conf "spark.yarn.user.classpath.first" required to force user classpath apart from extraClassPath. 

> [!Note]
> Jars can be loaded from Storage accounts its not needed to be on local disks. If you are using multiple jar files then list all the jar file with comma-separated.

```bash
curl -k --user "admin:Pass@word1" -v -H 'Content-Type: application/json' -X POST -d '{ "file":"wasbs:///sparkhbase/sparkhbase.jar", "className":"HBaseTest", "jars":["wasbs:///sparkhbase/mssql-jdbc-6.2.2.jre8.jar"],"conf":{ "spark.driver.extraClassPath":"wasbs:///sparkhbase/mssql-jdbc-6.2.2.jre8.jar","spark.yarn.user.classpath.first":"true"} }' "https://{clustername}.azurehdinsight.net/livy/batches"
```

The following `spark-submit` command is equivalent to the `curl` command used previously:

```bash
spark-submit --class HBaseTest --conf spark.yarn.user.classpath.first=true --conf spark.yarn.submit.waitAppCompletion=false --conf spark.jars=wasbs:///sparkhbase/mssql-jdbc-6.2.2.jre8.jar --conf spark.master=yarn-cluster --conf spark.driver.extraClassPath=wasbs:///sparkhbase/mssql-jdbc-6.2.2.jre8.jar  wasbs:///sparkhbase/sparkhbase.jar
```

The same parameters can be forwarded from ADF using the typeProperties, If your application requires multiple jar files you have an option to drop all the jar file under jars folder when using from ADF.

```json
"typeProperties": {    
    "rootPath": "sparktestadhoc/JarRoot",    
    "entryFilePath": "sparkhbase.jar",    
    "className": "HBaseTest",    
    "sparkConfig": {    
    "spark.driver.extraClassPath": "wasbs:///JarRoot/Jars",    
    "spark.yarn.user.classpath.first": "true"
}
```

For more information, see [Spark runtime environment configuration properties](https://spark.apache.org/docs/latest/configuration.html#runtime-environment).