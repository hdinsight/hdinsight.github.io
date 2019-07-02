| title  | description  | keywords  | services  |  documentationcenter | author  | manager  | editor  | ms.assetid  | ms.service  | ms.workload  | ms.tgt_pltfrm  | ms.devlang  | ms.topic  | ms.date  | ms.author  |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
| How to enable soft delete for different storage accounts?  Microsoft Docs  | Some tips about soft delete for each type of storage account. | Azure HDInsight, Yarn, soft delete, storage account, wasb, adls, abfs.  |  Azure HDInsight  | na  | marshall  | shravan  |  marshall | na  | multiple  | na  | na  | na  | article  | 07/02/2019  |  zhaya |
  
---
  
### Would the property in core-site.xml help?
>
> \<property>
>
>    \<name>fs.trash.interval\</name>
>
>    \<value>360\</value>
>
> \</property>
>
These property from core-site.xml are only applicable for local HDFS. These won't affect the remote storage accounts(WASB, ADLS GEN1, ABFS).
>
>[Offcial core-default.xml doc](https://hadoop.apache.org/docs/r2.7.3/hadoop-project-dist/hadoop-common/core-default.xml)  
>
According to the design of HDInsight structure, users shouldn't store any data in local file system, except for the temp files. (auto generated from tasks, etc.) Which means this property shouldn't ever be touched.

***
### How to enable the soft delete in Azure?
To un-delete the file from remote storage account, user should follow the corresponding instructions.

WASB:
>
>[storage-blob-soft-delete](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-blob-soft-delete)
>
>[undelete-blob](https://docs.microsoft.com/en-us/rest/api/storageservices/undelete-blob)
>
ADLS GEN1:
>
>[restore-azdatalakestoredeleteditem](https://docs.microsoft.com/en-us/powershell/module/az.datalakestore/restore-azdatalakestoredeleteditem?view=azps-1.6.0)
>
ABFS: （Not yet supported) 
>
>[data-lake-storage-known-issues](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-known-issues)
>






























