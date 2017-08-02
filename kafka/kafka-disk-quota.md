---
title: TSG: How can I configure Disk Quota for Kafka user? | Microsoft Docs
description: Use the Kafka FAQ for answers to common questions on Kafka on Azure HDInsight platform.
keywords: Azure HDInsight, Kafka, FAQ, troubleshooting guide, common problems
services: Azure HDInsight
documentationcenter: na
author: apadma
manager: ''
editor: ''

ms.assetid: 9ac53b42-9b66-424c-894c-90786b51d3b2
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 08/02/2017
ms.author: apadma
---

## How can I configure Disk Quota for Kafka user?

There are two types of disk quotas that can be enabled in debian based operating systems – User quota & group quota. Users can belong to multiple groups and they inherit the policies assigned to the group. In this manner, quotas can be configured for a user’s files separately from the files shared between users or between projects. For Kafka clusters,we only set a single user quota for the root partition.

The quota limits in OS VHD clusters are as follows: (Soft limit of 750 GB & Hard limit 800 GB)

```
Filesystem Blocks Soft Hard inodes Soft Hard 
dev/sda1     20 734003200 838860800 5 0 0
```
The columns above are as follows:

1 - Indicates the name of the file system that has a quota enabled

2 - Indicates the number of blocks currently used by the user

3 - Indicates the soft block limit for the user on the file system

4 - Indicates the hard block limit for the user on the file system

5 - Indicates the amount of inodes currently used by the user

6 - Indicates the soft inode limit for the user on the file system

7 - Indicates the hard inode limit for the user on the file system

The blocks refer to the amount of disk space, while the inodes refer to the number of files/folders that can be used. We are only interest in the block amount. The hard block limit is the absolute maximum amount of disk space that a user or group can use. Once this limit is reached, no further disk space can be used. The soft block limit defines the maximum amount of disk space that can be used. However, unlike the hard limit, the soft limit can be exceeded for a certain amount of time. This time is known as the grace period and is by default set to 7 days.

### Common disk quota Operations:

Turn off disk quota: 
```Sudo quotaoff -a /```

View current disk quota statistics: 
```Sudo repquota /```

View graceperiod: 
```Sudo edquota -t```

Set block hard limit for Kafka user:
```
SOFT_LIMIT=750G
HARD_LIMIT=800G
sudo quotatool -u kafka -bq $SOFT_LIMIT -l $HARD_LIMIT /
```