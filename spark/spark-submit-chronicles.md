---
title: Options to use Spark Submit? | Microsoft Docs
description: Use the Spark FAQ for answers to common questions on Spark on Azure HDInsight platform.
keywords: Azure HDInsight, FAQ, troubleshooting guide, common problems, remote submission
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
ms.date: 02/01/2018
ms.author: sunilkc
---

# Azure HDInsight Solutions | Apache Spark | Using Spark-Submit to create Apache Spark jobs

## Scenario: You would like to use the spark-submit shell script to create Apache Spark jobs, but the required parameters are unclear.

Three Parameters listed below are used to load external jar file.

```
spark.driver.extraClassPath
spark.yarn.user.classpath.first
spark.executor.extraClassPath
```

##### Following curl command submits spark application with additional conf "spark.yarn.user.classpath.first" required to force user classpath apart from extraClassPath. 
-   Jars can be loaded from Storage accounts its not needed to be on local disks. 
-   If you are using multiple jar files then list all the jar file with comma-separated.
 
 ```
curl -k --user "admin:Pass@word1" -v -H 'Content-Type: application/json' -X POST -d '{ "file":"wasbs:///sparkhbase/sparkhbase.jar", "className":"HBaseTest", "jars":["wasbs:///sparkhbase/mssql-jdbc-6.2.2.jre8.jar"],"conf":{ "spark.driver.extraClassPath":"wasbs:///sparkhbase/mssql-jdbc-6.2.2.jre8.jar","spark.yarn.user.classpath.first":"true"} }' "https://{clustername}.azurehdinsight.net/livy/batches"  ```
```

Here is an example for spark-submit, above curl almost translates to the following spark-submit

```
spark-submit --class HBaseTest --conf spark.yarn.user.classpath.first=true --conf spark.yarn.submit.waitAppCompletion=false --conf spark.jars=wasbs:///sparkhbase/mssql-jdbc-6.2.2.jre8.jar --conf spark.master=yarn-cluster --conf spark.driver.extraClassPath=wasbs:///sparkhbase/mssql-jdbc-6.2.2.jre8.jar  wasbs:///sparkhbase/sparkhbase.jar
```

##### Same parameters can be forwarded from ADF using the typeProperties, If you applicaiton require multiple jar files you have an option to drop all the jar file under jars folder when using from ADF.

```
"typeProperties": {    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"rootPath": "sparktestadhoc/JarRoot",    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"entryFilePath": "sparkhbase.jar",    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"className": "HBaseTest",    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"sparkConfig": {    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"spark.driver.extraClassPath": "wasbs:///JarRoot/Jars",    
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"spark.yarn.user.classpath.first": "true"
},
...
```

https://spark.apache.org/docs/latest/configuration.html#runtime-environment
