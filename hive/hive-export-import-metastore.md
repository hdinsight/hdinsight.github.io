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

### Export metadata from internal Hive metastore on HDInsight

This article shows how to export Apache Hive and LLAP workloads from an HDInsight cluster with an internal Hive metastore and import them to an external metastore. This is useful for scaling up the SQL Database or for [migrating workloads from HDInsight 3.6 to HDInsight 4.0](https://docs.microsoft.com/en-us/azure/hdinsight/interactive-query/apache-hive-migrate-workloads).

To export data from an external Hive metastore, we could copy the SQL Database and, optionally, upgrade the schema for HDInsight 4.0 compatibility. For an internal Hive metastore, however, restricted access to the SQL resource requires us to use Hive. This article provides a script that generates an HQL script to recreate Hive databases, tables, and partitions in another cluster. HDInsight 4.0 also covers constraints, views, and materialized views. Other metadata objects, like UDFs, must be copied manually.

> [!NOTE]
>
> * All managed tables will become transactional if the output HDInsight version is 4.0. Optionally, make the table non-transactional by exporting the data to an external table with the property 'external.table.purge'='true'. For example,
>
>    ```SQL
>    create table tablename_backup like tablename;
>    insert overwrite table tablename_backup select * from tablename;
>    create external table tablename_tmp like tablename;
>    insert overwrite table tablename_tmp select * from tablename;
>    alter table tablename_tmp set tblproperties('external.table.purge'='true');
>    drop table tablename;
>    alter table tablename_tmp rename to tablename;
>
> * This procedure preserves non-ACID table locations. You can manually edit the DDL in
`alltables.hql`, generated from the script, to reflect any location changes.
>
>     Note: *For ACID tables, a new copy of the data will be created*.
>
> * The procedure assumes that after completion, the old cluster will **not** be used any longer.

#### Prerequisites

* If exporting from an HDInsight 4.0 cluster, set `hive.security.authorization.sqlstd.confwhitelist.append=hive.ddl.output.format` in Custom hive-site via Ambari and restart Hive.

* Prepare a new Hadoop or Interactive Query HDInsight cluster, attached to an external Hive metastore and to the same Storage Account as the source cluster. The new HDInsight version must be 4.0 if the source version is 4.0.

#### Migrate from internal metastore

1) [Connect to the HDInsight Cluster using SSH](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-linux-use-ssh-unix), to the primary headnode.

1) As root user and from a new directory, download and run the script, which generates a file named `alltables.hql`:

    ```bash
    sudo su
    SCRIPT="exporthive.sh"
    wget "https://hdiconfigactions.blob.core.windows.net/hivemetastoreschemaupgrade/$SCRIPT"
    chmod 755 "$SCRIPT"
    exec "./$SCRIPT"
    ```

1) Copy the file `alltables.hql` to the new HDInsight cluster and from the new cluster, run the following command:

    * For non-ESP:

        ```bash
        beeline -u "jdbc:hive2://localhost:10001/;transportMode=http" -f alltables.hql
        ```

    * for ESP:

        ```bash
        USER="USER"  # replace USER
        DOMAIN="DOMAIN"  # replace DOMAIN
        DOMAIN_UPPER=$(printf "%s" "$DOMAIN" | awk '{ print toupper($0) }')
        kinit "$USER@$DOMAIN_UPPER"
        hn0=$(grep hn0- /etc/hosts | xargs | cut -d' ' -f4)
        beeline -u "jdbc:hive2://$hn0:10001/default;principal=hive/_HOST@$DOMAIN_UPPER;auth-kerberos;transportMode=http" -n "$USER@$DOMAIN" -f alltables.hql
        ```

#### Further Reading

1) [Connect to HDInsight using SSH](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-linux-use-ssh-unix)
1) [Migrate workloads from HDInsight 3.6 to 4.0](https://docs.microsoft.com/en-us/azure/hdinsight/interactive-query/apache-hive-migrate-workloads)
1) [Use external metastore with HDInsight](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-use-external-metadata-stores)
1) [Connect to Beeline on HDInsight](https://docs.microsoft.com/en-us/azure/hdinsight/hadoop/connect-install-beeline)
