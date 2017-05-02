---
title: How do I export Hive metastore and import it on another HDInsight cluster? | Microsoft Docs
description: Use the Hive FAQ for answers to common questions on Hive on Azure HDInsight platform.
keywords: Azure HDInsight, Hive, FAQ, troubleshooting guide, export metastore, import metastore
services: Azure HDInsight
documentationcenter: na
author: dkakadia
manager: ''
editor: ''

ms.assetid: 15B8D0F3-F2D3-4746-BDCB-C72944AA9252
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 04/10/2017
ms.author: dkakadia

---

### How do I export Hive metastore and import it on another HDInsight cluster?

#### Issue:

Need to export Hive metastore and import it on another HDInsight cluster.  

#### Resolution Steps: 

1) Connect to the HDInsight cluster with a Secure Shell (SSH) client (check Further Reading section below).

2) Run the following command on the HDInsight cluster where from you want to export the metastore:

~~~
for d in `hive -e "show databases"`; do echo "create database $d; use $d;" >> alltables.sql ; for t in `hive --database $d -e "show tables"` ; do ddl=`hive --database $d -e "show create table $t"`; echo "$ddl ;" >> alltables.sql ; echo "$ddl" | grep -q "PARTITIONED\s*BY" && echo "MSCK REPAIR TABLE $t ;" >> alltables.sql ; done; done
~~~

This will generate a file named `allatables.sql`.

3) Copy the file `alltables.sql` to the new HDInsight cluster and run the following command:

~~~
hive -f alltables.sql
~~~

Note: This assumes that data paths on new cluster are same as on old. If not, you can manually edit the generated  
`alltables.sql`  file to reflect any changes.

#### Further Reading:

1) [Connect to HDInsight Cluster using SSH](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-linux-use-ssh-unix)