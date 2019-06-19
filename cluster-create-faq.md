---
title: Azure HDInsight Solutions | HDinsight Cluster Create |  Frequently Asked Questions
description: FAQ that would be helpful to resolve Cluster Crate issues.
services: hdinsight
author: csunilkumar
ms.author: sunilkc
ms.service: hdinsight
ms.custom: FAQ
ms.topic: conceptual
ms.date: 06/18/2019
---

# Azure HDInsight Solutions | HDinsight Cluster Create | Frequently Asked Questions

## Cluster creation is failing when configured to use [Azure Data Lake Storage Gen2](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction) as storage.

- Confirm if you have [set-up-permissions-for-the-managed-identity-on-the-data-lake-storage-gen2-account](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-use-data-lake-storage-gen2#set-up-permissions-for-the-managed-identity-on-the-data-lake-storage-gen2-account)


## Unable to create [Machine Learning Services Cluster](https://docs.microsoft.com/en-us/azure/hdinsight/r-server/r-server-overview) in Azure HDInsight configured to use [Azure Data Lake Storage Gen2](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction)

- HDInsight clusters includes the new [Azure Blob Filesystem](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-abfs-driver) driver required to connect to Azure Data Lake Storage Gen2.
ABFS Driver is available only on HDInsight 3.6 cluster with minor version of 1000.65,  starting from 3.6.1000.65 and above.
Where as Machine Learning Services image version is lesser than 3.6.1000.65, one cannot create HDInsight Machine Learning Services cluster type with ADL Gen2 as ABFS driver is not available.
