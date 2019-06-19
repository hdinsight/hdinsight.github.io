---
title: Azure HDInsight Solutions | Ambari Issue |  Frequently Asked Questions
description: FAQ that would be helpful to resolve Ambari relate issues
services: hdinsight
author: csunilkumar
ms.author: sunilkc
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: <date>
---

# Azure HDInsight Solutions | Ambari Issue  | Frequently Asked Questions

## Unable to Access Ambari UI on HDInsight Clusters
Are you prompted for credentials when you are access Ambari UI on HDInsight ?
- Does the request fail after you enter valid Credentials ? 

Users are not getting prompted for credentials when they access Ambari UI on HDInsight clusters using Fully Qualified Domain name ex. https://{clustername},azurehdinsight.net.
-   check your network settings to confirm there is no connectivity issue between the client and the Azure HDInsight Clusters


Is it possible to Decommission WorkerNode 0 from the backend ?
- Even when cluster is scaled down to 1 node, worker node 0 will still survive. As with the Scaling logic Worker Node 0 can never be decommissioned.
- If you identify an issue with specific node please troubleshoot the issue to understand the cause for the issue and find the resolution.
