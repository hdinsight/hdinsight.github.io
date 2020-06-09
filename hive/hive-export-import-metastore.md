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

* See [apache-hive-migrate-workloads](https://docs.microsoft.com/en-us/azure/hdinsight/interactive-query/apache-hive-migrate-workloads) for migration of an external metastore, or for upgrading Hive from HDInsight 3.6 to 4.0.

* This current article gives instructions on using a script to export/import contents of an internal Hive metastore.

* Import works only if the destination cluster shares the same Storage Account as the source cluster.

> [!NOTE]
>
> * The script supports copying of tables and partitions. For HDInsight 4.0, it additionally covers constraints, views, and materialized views. Other metadata objects, like UDFs, must be copied manually.
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
`alltables.hql`, generated from the script, to reflect any location changes. *For ACID tables, a new copy of the data will be created*.
>
> * The procedure assumes that after completion, the old cluster will **not** be used any longer.

#### Resolution Steps:

If migrating from an external metastore, follow steps in [apache-hive-migrate-workloads](https://docs.microsoft.com/en-us/azure/hdinsight/interactive-query/apache-hive-migrate-workloads). Otherwise, follow steps below.

1) [Connect to the HDInsight Cluster using SSH](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-linux-use-ssh-unix), to the primary headnode.

1) Download the export script from an ssh session to the cluster:

    ```bash
    wget "https://hdiconfigactions.blob.core.windows.net/hivemetastoreschemaupgrade/$SCRIPT"
    chmod 755 "$SCRIPT"
    ```

    where `SCRIPT="exporthive_hdi_3_6.sh"` for HDInsight 3.6 or `SCRIPT="exporthive_hdi_4_0.sh"` for HDInsight 4.0.

1) Run the script from the cluster:

    * For HDInsight 4.0, follow these additional steps, first:

        a. Download a helper script used by `exporthive_hdi_4_0.sh`.

        ```bash
        wget "https://hdiconfigactions.blob.core.windows.net/hivemetastoreschemaupgrade/constraints2altertable.py"
        chmod 755 constraints2altertable.py
        ```

        b. set hive.security.authorization.sqlstd.confwhitelist.append=hive.ddl.output.format in Custom hive-site via Ambari.

    * For a non-ESP cluster, simply execute the script.
    * For an ESP cluster, kinit with user with full Hive permissions, and then execute the script with modified beeline arguments:

        ```bash
        USER="USER"  # replace USER
        DOMAIN="DOMAIN"  # replace DOMAIN
        DOMAIN_UPPER=$(printf "%s" "$DOMAIN" | awk '{ print toupper($0) }')
        kinit "$USER@$DOMAIN_UPPER"
        ```

        ```bash
        hn0=$(grep hn0- /etc/hosts | xargs | cut -d' ' -f4)
        BEE_CMD="beeline -u 'jdbc:hive2://$hn0:10001/default;principal=hive/_HOST@$DOMAIN_UPPER;auth-kerberos;transportMode=http' -n "$USER@$DOMAIN" --showHeader=false --silent=true --outputformat=tsv2 -e"
        ./exporthive_hdi_3_6.sh "$BEE_CMD"  # replace script with exporthive_hdi_4_0.sh for 4.0
        ```

    This will generate a file named `alltables.hql`.

1) Copy the file `alltables.hql` to the new HDInsight cluster and run the following command:

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
        ```

        ```bash
        hn0=$(grep hn0- /etc/hosts | xargs | cut -d' ' -f4)
        beeline -u "jdbc:hive2://$hn0:10001/default;principal=hive/_HOST@$DOMAIN_UPPER;auth-kerberos;transportMode=http" -n "$USER@$DOMAIN" -f alltables.hql
        ```
