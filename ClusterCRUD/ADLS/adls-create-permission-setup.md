---
title: ADLS cluster creation - storage container permissions setup | Microsoft Docs
description: Permission setup on ADL storage cluster container
services: hdinsight
documentationcenter: ''
author: vahemesw
manager: vinayb

ms.service: hdinsight
ms.custom: hdinsightactive
ms.devlang: na
ms.topic: article
ms.tgt_pltfrm: na
ms.workload: big-data
ms.date: 10/09/2017
ms.author: vahemesw
---

#### Permissions to be set on storage container for ADLS cluster creation

When creating clusters with DataLake as primary storage, a container is configured under which all the cluster-specific files will be stored.

User specifies a root path, path from root of storage account to cluster container, for eg. '/A/Clusters/clustername'. If root path is ‘/A/Clusters/clustername’, ‘clustername’ is the container under which the files/folders for the cluster are placed

If root path is configured as ‘/A/Clusters/clustername’, make sure that the folder ‘/A/clusters’ exists.

####Summary of permissions required: 
- If '/A/Clusters/clustername' folder exists
	- Service principal requires execute(x) permission at ‘/’, '/A' and ‘/Clusters’ and any other intermediate folders till the container (required for traversal)
	- Service principal requires ‘rwx’ permission on ‘/A/Clusters/clustername’ (required to copy files to container)
- If ‘/A/Clusters/clustername’ does not exist
	- Service principal requires execute(x) permission at ‘/’, '/A' and other intermediate folders till 'clusters'
	- Service principal requires ‘-wx’ permission on ‘/A/Clusters’ (required to create ‘clustername’ folder)

See [ADLS Access Control](https://docs.microsoft.com/en-us/azure/data-lake-store/data-lake-store-access-control) for detailed explanation of this setup.

See [Re-use existing container](../ADLS/adls-create-reuse-container.md) for additional setup required to use an existing container.

#### Possible errors

Error message during cluster creation will prompt "DataLake storage account not configured properly. Please check folder permissions." if the folder permissions are not properly setup.

#### Related links 

[Create DataLake clusters from portal](https://docs.microsoft.com/en-us/azure/data-lake-store/data-lake-store-hdinsight-hadoop-use-portal)
[Configure multiple datalake clusters in an ADLS account](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-multiple-clusters-data-lake-store)