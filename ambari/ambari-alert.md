---
title: Azure HDInsight Solutions | <Feature_Area> | <Problem Type>
description: Learn how to resolve <scenario>
services: hdinsight
author: confusionblinds
ms.author:sunilkc
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: Ambari Alert
ms.date: 11/04/2018
---

# Azure HDInsight Solutions | Ambari Alerts | Debugging Ambari Alerts

## Troubleshooting Ambari Alerts.
Ambari alert log path ```/var/log/ambari-server/ambari-alerts.log```

### Enabling debug log for Ambari alert requires changing following in file ```/etc/ambari-server/conf/log4j.properties```

From 
```
# Log alert state changes
log4j.logger.alerts=INFO,alerts
```
<br>

To <br>
```
# Log alert state changes
log4j.logger.alerts=DEBUG,alert```
