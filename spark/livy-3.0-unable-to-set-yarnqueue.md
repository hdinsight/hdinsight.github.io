---
title: Queue Name is honored in livy 0.3? | Microsoft Docs
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


#### Unable to configure YARN queue name from jupyter that uses livy 0.3
### YARN provides feature to create a new Yarn queue with capacity allocation on HDInsight cluster.
    https://hdinsight.github.io/yarn/yarn-create-new-queue.html

### When Queue Name is passed from Jupyter notebooks the same is not honored by livy 0.3.0 when executing an application in interactive session

```
%%configure
{ "queue":"newqueue","name":"somename"}
```

With following curl command, the job showed up under the new queue name "newqueue". This confirmed that the queue name is honored for batch sessions on livy 0.3.0
 
 ```
curl -k --user "admin:Password1.." -v -H 'Content-Type: application/json' -X POST -d '{ "file":"wasbs:///sparksqldb/sparkhbase.jar", "className":"HBaseTest", "jars":["wasbs:///sparksqldb/mssql-jdbc-6.2.2.jre8.jar"],"queue":"newqueue","conf":{ "spark.driver.extraClassPath":"wasbs:///sparksqldb/mssql-jdbc-6.2.2.jre8.jar","spark.yarn.user.classpath.first":"true"} }' "https://sparkclustername.azurehdinsight.net/livy/batches"
 ```
 
Try executing a interactive session application found the application was still getting executed in default queue.

```
curl -k --user "admin:Password1.." -v -H 'Content-Type: application/json' -X POST -d '{ "queue":"newqueue","name":"newname01"}' "https://sparkclustername.azurehdinsight.net/livy/sessions"
```
#### Conclusion
Queue name even when forwarded is not honored on livy 0.3 when the job is executed in session mode. This issue has been fixed in in livy 0.4.

