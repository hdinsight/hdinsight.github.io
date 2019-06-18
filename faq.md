---
title: Azure HDInsight Solutions | <Feature_Area> | <Problem Type>
description: Learn how to resolve <scenario>
services: hdinsight
author: <author_github_account>
ms.author: <author_ms_alias>
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: <date>
---

# Azure HDInsight Solutions | HDInsight | Frequently Asked Questions

## Unable to create [Machine Learning Services Cluster](https://docs.microsoft.com/en-us/azure/hdinsight/r-server/r-server-overview) in Azure HDInsight configured to [Azure Data Lake Storage Gen2](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-introduction)

HDInsight clusters includes the new [Azure Blob Filesystem](https://docs.microsoft.com/en-us/azure/storage/blobs/data-lake-storage-abfs-driver) Driver required to connected to Azure Data Lake Storage Gen2.
ABFS Driver is available only on HDInsight 3.6 cluster with minor version of 1000.65,  starting from 3.6.1000.65 and above.
Where as Machine Learning Services image version is lesser than 3.6.1000.65, one cannot create HDInsight Machine Learning Services cluster type with ADL Gen2 configure as store.

