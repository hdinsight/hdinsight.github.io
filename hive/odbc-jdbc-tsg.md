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

What is Beeline?  
Beeline is a thin client that connects to HiveServer2 using Hive JDBC driver and executes queries through HiveServer2.  Beeline unlike hive does not require the installation of Hive libraries on the same machine as the client.

## Scenario: 
  -  Getting error ```The remote server returned an error: (502) Bad Gateway``` frequently when connecting to Hive on HDInsight cluster using ODBC / JDBC Drivers.
## Scoping Questions:
  -   Is the Hiveserver2 running
  -   Can you successfully connect to hive using JDBC connectivity from beeline:
  [Beeline client with Apache Hive](https://docs.microsoft.com/en-us/azure/hdinsight/hadoop/apache-hadoop-use-hive-beeline)
  -   If cusotmer is using a Thirdparty Client Application to connect to Hive then the first confirm the connection using Microsoft® Hive ODBC Driver
  [Connect Excel to Apache Hadoop in Azure HDInsight with the Microsoft Hive ODBC driver](https://docs.microsoft.com/en-us/azure/hdinsight/hadoop/apache-hadoop-connect-excel-hive-odbc-driver)
  -   Are there too many YARN jobs taking up resources.
  


