---
title: TSG: How can I setup OMS for Kafka? | Microsoft Docs
description: Use the Kafka FAQ for answers to common questions on Kafka on Azure HDInsight platform.
keywords: Azure HDInsight, Kafka, FAQ, troubleshooting guide, common problems
services: Azure HDInsight
documentationcenter: na
author: apadma
manager: ''
editor: ''

ms.assetid: 4fc0a9d3-4ac5-428a-9c1a-75f5be20b61b
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 08/02/2017
ms.author: apadma
---

## How can I setup OMS for Kafka?

### Setup via HDInsight Script Action
1) Custom action script to install & configure OMS for Kafka are located [Storm.](https://000aarperiscus.blob.core.windows.net/oms/kafka/HdiKafkaOmsInstallation.sh)
2) Navigate to the cluster page on the Azure Management portal.
3) Select “Custom Action scripts”
4) Provide the script from Step #1 as the script path.
5) Parameters = <OMS WorkspaceID> <OMS Primary Key>. The workspace id and primary key can be obtained from the OMS Management page. (OMS Management Page > Settings > Connected sources > Linux servers)
6) Execute the script on the head nodes and worker nodes.
7) Once the script execution completes, wait for about ~20 minutes for data to be collected.
8) Logon to OMS management portal and you should see data flowing in.

Note for old clusters (created before 11/15/2016):
Kafka exposes JMX metrics on port 9999. However, for Hdinsight clusters created before 11/15/2016, this is not the case. For these old clusters, please logon to Ambari, and add the following to live advanced-kafka-env: export JMX_PORT=${JMX_PORT:-9999}
You may need to restart kafka brokers after this for it to take effect.

### Querying/Visualizing OMS Data

Navigate to OMS Portal > Log Search. 

Here are some sample queries you can do:

1. View all metrics
Type * into log search. This will show you all types ingested into OMS. For the moment we capture the below entries:

| Tables                  | Details                             |
| ----------------------- |-------------------------------------|
| log_kafkaserver_CL      | Kafka broker's server.log file      |
| log_kafkacontroller_CL  | Kafka broker's controller.log file  |
| kafkametrics_CL         | Kafka JMX metrics                   |


2. Disk Usage:
```
Type=Perf ObjectName="Logical Disk" (CounterName="Free Megabytes")  InstanceName="_Total" Computer='hn*-*' or Computer='wn*-*' 
| measure avg(CounterValue) by   Computer interval 1HOUR
```

3. CPU Usage:
```
Type:Perf CounterName="% Processor Time" InstanceName="_Total" Computer='hn*-*' or Computer='wn*-*' 
| measure avg(CounterValue) by Computer interval 1HOUR
```

4. Incoming Messages per second:
```
Type=kafkametrics_CL ClusterName_s="kafkaomstest3" InstanceName_s="kafka-BrokerTopicMetrics-MessagesInPerSec-Count" 
| measure avg(kafka_BrokerTopicMetrics_MessagesInPerSec_Count_value_d) by HostName_s interval 1HOUR
```

5. Incoming Bytes per second:
```
Type=kafkametrics_CL HostName_s="wn0-kafkao" InstanceName_s="kafka-BrokerTopicMetrics-BytesInPerSec-Count"  
| measure avg(kafka_BrokerTopicMetrics_BytesInPerSec_Count_value_d) interval 1HOUR
```

6. Outgoing Bytes per second:
```
Type=kafkametrics_CL ClusterName_s="kafkaomstest3" InstanceName_s="kafka-BrokerTopicMetrics-BytesOutPerSec-Count" 
| measure avg(kafka-BrokerTopicMetrics-BytesOutPerSec-Count_value_d) interval 1HOUR
```