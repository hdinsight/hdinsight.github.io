---
title: HBase hbck returns inconsistencies | Microsoft Docs
description: How to fix the inconsistencies returned by hbck check
services: hdinsight
documentationcenter: ''
author: duoxu
manager: mitrabmo

ms.service: hdinsight
ms.custom: hdinsightactive
ms.devlang: na
ms.topic: article
ms.tgt_pltfrm: na
ms.workload: big-data
ms.date: 04/04/2018
ms.author: duoxu
---

# holes in the region chain

Usually it is due to some regions are offline, thus hbck reports that there are some holes in the region chain. Look at below how to bring up those offline regions and this inconsistency should be automatically fixed.

# region xxx on HDFS, but not listed in hbase:meta or deployed on any region server

If the region is not in hbase:meta, you should first fix the meta table by running "hbase hbck -ignorePreCheckPermission –fixMeta" and then "hbase hbck -ignorePreCheckPermission –fixAssignment" to assign these regions to regionservers.

# region xxx not deployed on any region servewr
This means the region is in hbase:meta, but offline. You should bring it up by "hbase hbck -ignorePreCheckPermission –fixAssignment". If there are any regions stuck in transition (from HBase HMaster UI), you can follow

###### [How to fix timeout issue with 'hbase hbck' command when fixing region assignments?](hbase-hbck-timeout.md)

# regions having the same start/end keys

In this case you need to manually merge those overlapped regions.

Go to HBase HMaster Web UI table section, click the table link which has the issue in step 3, you will see start key/end key of each region belonging to that table. Then merge those overlapped regions.
In HBase shell, do “merge_region ‘xxxxxxxx’,’yyyyyyy’, true”. For example,

RegionA, startkey:001, endkey:010, 

RegionB, startkey:001, endkey:080,

RegionC, startkey:010, endkey:080.

In this scenario, you need to merge RegionA and RegionC and get RegionD with the same key range as RegionB, then merge RegionB and RegionD.
xxxxxxx and yyyyyy are the hash string at the end of each region name. Be careful here not to merge two discontinuous regions. After each merge like merge A and C, HBase will start a compaction on RegionD, you need to wait for it to finish before doing another merge with RegionD, you can find the compaction status on that region server page in HBase HMaster UI.


# couldn't load .regioninfo for region /hbase/data/default/tablex/regiony

This is most likely due to region partial deletion when regionserver crashes or VM reboots. Currently the Azure Storage is a flat blob file system and some file operations are not atomic, although they are working on a new file system which will address such issues. For now, you need to manually clean up these remaining files and folders.

Firstly, run "hdfs dfs -ls /hbase/data/default/tablex/regiony" to check what folders/files are still under it.

Secondly, run "hdfs dfs -rmr /hbase/data/default/tablex/regiony/filez" to delete all child files/folders

Thirdly, run "hdfs dfs -rmr /hbase/data/default/tablex/regiony" to delete the region folder.
        