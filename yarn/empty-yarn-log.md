---
title: How can I download and read Yarn log from storage account directly? | Microsoft Docs
description: Use the Yarn FAQ for answers to common questions on Yarn on Azure HDInsight platform.
keywords: Azure HDInsight, Yarn, FAQ, troubleshooting guide, download logs, ADLS storage.
services: Azure HDInsight
documentationcenter: na
author: zhaya
manager: ''
editor: ''

ms.topic: article
ms.date: 08/22/2019
ms.author: zhaya

---

### How can I download and read Yarn log from storage account directly?

Have you tried to download the log through Yarn API?
[This might help](yarn-download-logs.md)

#### Issue:
The logs found from storage account is not human-readable. The file parser doesn't work with java.io.IOException: Not a valid BCFile.

#### Mitigation Step:
This is because Yarn log is aggregated into IndexFile format, which is not supported by the file parser we have. 

* For **WASB storage**. From Ambari, change the config of yarn-site.xml. 
```
yarn.log-aggregation.file-formats = IndexedFormat,TFile
```
You should see IndexedFormat,TFile as default. Remove IndexedFormat, leave TFile.
```
yarn.log-aggregation.file-formats = TFile
```
Restart all the affected services and now you should be able to get TFile logs from storage and read with the parser.


* If you are using **ADLS storage**, there's issue for the TFile log. Please do the following 
```
yarn.nodemanager.log-aggregation.compression-type = gz
```
You should see compression type set to gz by default. Please change the value to "none" to make it work.
```
yarn.nodemanager.log-aggregation.compression-type = none
```
By using IndexedFormant + none compression, you should be able to read the log file directly from storage account.
