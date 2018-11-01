---
title: Azure HDInsight Solutions | Apache Spark | Streaming Application Fails Without Error
description: Learn how to resolve streaming application failures without error.
services: hdinsight
author: confusionblinds
ms.author: sunilkc
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: 10/31/2018
---
# Azure HDInsight Solutions | Apache Spark | Streaming Application Fails Without Error

## Scenario: A Spark Streaming application stops processing data after executing for 24 days with no known errors in the logs.

## Issue

An HDInsight Spark Streaming application stops after executing for 24 days and there are no errors in the log files.

## Cause

The `livy.server.session.timeout` value controls how long Livy should wait for a session to complete. Once the session length reaches the `session.timeout` value, the Livy session and the application are automatically killed.

## Solution

For long running jobs, increase the value of `livy.server.session.timeout` using the Ambari UI. You can access the Livy configuration from the Ambari UI using the link https://<yourclustername>.azurehdinsight.net/#/main/services/LIVY/configs.

Replace <yourclustername> with the name of your HDInsight cluster as shown in the portal.