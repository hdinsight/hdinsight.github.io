---
title: Azure HDInsight Solutions | Hive | HIve Logs are filling up disk space on headnodes
description: Learn Hive log setting to tweaks log file generation
services: hdinsight
author: csunilkumar
ms.author: sunilkc
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: 02/24/2019
---
# Azure HDInsight Solutions | Hive |  Understanding hive log setting to better utilize disk space

## Scenario: HIve Logs are filling up disk space on headnodes

## Issue
  Hive logs files was taking up most of the Disk Space on Headnode

## Details & Recommendations
hive-log4j.properties file stored under ```/etc/hive/<hdpversion>/0``` contains all the configuration for all Hive Logging. 
To edit this file from Ambari UI follow the steps below.
- Click **Hive** service on the left-hand side of the ambari dashboard.
- Click **Config** tab that shows up on Service Summary page.
- Click the **Advanced** tab underneath the Version History Timeline, then search for the **Advanced hive-log4j** entry. 
- Or Search for 'Advanced hive-log4j' in the search bar at the top-right of the screen and Ambari will highlight the relevant settings.

## 
Hive Logs file entries are primarily driven by two settings.  
Ex: ```hive.root.logger=DEBUG,RFA```
- [Log Level](https://logging.apache.org/log4j/2.x/log4j-api/apidocs/org/apache/logging/log4j/Level.html)
  - By Default log level is set to **DEBUG**
  - To Reduce log file size change Log Level to **INFO** to print less logs entries
- Number of log file generated for a day is controlled by File appender
  - Daily Rolling File Appender - DRFA - By default, rolls every day creating 1 file a day.
  - Rolling File Appender  - RFA - Depends on maxfilesize and  maxbackupindex. 
- **maxfilesize** and **maxbackupindex** parameters. 
  - Please use the setting similar to the one in newly created cluster.
  - If **log4j.appender.RFA.MaxBackupIndex** parameter has been omitted, the log files will be generated endless.

```
hive.root.logger=DEBUG,RFA
hive.log.dir=${java.io.tmpdir}/${user.name}
hive.log.file=hive.log

log4jhive.log.maxfilesize=1024MB
log4jhive.log.maxbackupindex=10


log4j.rootLogger=${hive.root.logger}, EventCounter, ETW, FullPIILogs
log4j.threshold=${hive.log.threshold}

log4j.appender.RFA=org.apache.log4j.RollingFileAppender
log4j.appender.RFA.File=${hive.log.dir}/${hive.log.file}
log4j.appender.RFA.MaxFileSize=${log4jhive.log.maxfilesize}
log4j.appender.RFA.MaxBackupIndex=${log4jhive.log.maxbackupindex}
```
