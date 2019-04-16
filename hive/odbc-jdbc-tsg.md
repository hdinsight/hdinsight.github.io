---
title: Azure HDInsight Solutions | Hive| ODBC / JDBC connectivity Issues
description: Article details guidance / Steos to Troubleshooting ODBC / JDBC connectivity issue
services: hdinsight
author: <author_github_account>
ms.author: <author_ms_alias>
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: <date>
---

# Azure HDInsight Solutions | Hive | ODBC / JDBC connectivity Issues

## Scenario: 
  -  Getting error ```The remote server returned an error: (502) Bad Gateway``` frequently when connecting to Hive on HDInsight cluster using ODBC / JDBC Drivers.
## Scoping Questions:
  -   Is the Hiveserver2 running
  -   Can you successfully connect to hive using JDBC connectivity from beeline:
  [Beeline client with Apache Hive](https://docs.microsoft.com/en-us/azure/hdinsight/hadoop/apache-hadoop-use-hive-beeline)
  -   Are there too many YARN jobs taking up resources.
  


