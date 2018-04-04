---
title: HBase table not able to read or write | Microsoft Docs
description: Common cases explaining why HBase table is not able to read and write
services: hdinsight
documentationcenter: ''
author: duoxu
manager: ashitg

ms.service: hdinsight
ms.custom: hdinsightactive
ms.devlang: na
ms.topic: article
ms.tgt_pltfrm: na
ms.workload: big-data
ms.date: 01/22/2018
ms.author: duoxu
---

# Storage exception: Connection Reset causing table truncating half-done

We have a customer periodically running the truncating table process on HBase cluster. There was a short time period of Storage connection issue causing the truncating half-done: the table entry was deleted in hbase metadata table, and most of table files had been deleted, only one blob file "/hbase/data/default/ThatTable/80b488992339bc79ef79d8c11b8214124/recovered.edits/0000000000000052121” left there. From the stale Master UI, you will see the table still there, but with 0 online regions and 0 offline regions. 

Although there is no folder blob called "/hbase/data/default/ThatTable" sitting in the storage. Our WASB driver finds the existence of the above blob and will not allow to create any blob called "/hbase/data/default/ThatTable" because it assumed the parent folders existing, thus creating table will fail.

The mitigations are

1. From ambari UI, restart the active HMaster. This will let one of the two standby HMaster becoming the active one and the new active HMaster will reload the metadata table info. Thus you will not see the "already-deleted" table in HMaster UI.

2. You can find the orphan blob file from UI tools like "cloudExplorer" or running command like "hdfs dfs -ls /xxxxxx/yyyyy". Run "hdfs dfs -rmr /xxxxx/yyyy" to delete that blob. Here is "hdfs dfs -rmr /hbase/data/default/ThatTable/80b488992339bc79ef79d8c11b8214124/recovered.edits/0000000000000052121".

3. Now you can create new table with the same name in HBase.

# HBCK returns holes in the region chain

Usually it is due to some regions are offline, thus hbck reports that there are some holes in the region chain. The read and write are not able to reach those offline regions. Please take a look at the below TSG to bring up the offline regions.
 
###### [HBase hbck returns inconsistencies](hbase-hbck-returns-some-regions-having-the-same-start-or-end-key.md)




