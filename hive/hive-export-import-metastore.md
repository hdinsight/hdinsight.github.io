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

* For migration of external metastore, follow steps to make a copy of the SQL Database in [apache-hive-migrate-workloads](https://docs.microsoft.com/en-us/azure/hdinsight/interactive-query/apache-hive-migrate-workloads.) If migrating from 3.6 to 4.0 cluster, follow steps to upgrade the schema.

* If we plan to export from an internal metastore, or if we plan to import from a 4.0 to 3.6 cluster, then use the script described below to export/import metadata objects as HQL.

* Import works only if destination cluster shares the same Storage Account as the source cluster.

#### Resolution Steps: 

If migrating from an external metastore, follow steps in [apache-hive-migrate-workloads](https://docs.microsoft.com/en-us/azure/hdinsight/interactive-query/apache-hive-migrate-workloads.). Otherwise, follow steps below.

1) Connect to the HDInsight cluster with a Secure Shell (SSH) client (check Further Reading section below).

1) Download the export script to the cluster:

    ```bash
    wget "https://hdiconfigactions.blob.core.windows.net/hivemetastoreschemaupgrade/$SCRIPT"
    chmod 755 "$SCRIPT"
    ```

    where `SCRIPT="exporthive_hdi_3_6.sh"` for HDInsight 3.6 or `SCRIPT="exporthive_hdi_4_0.sh"` for HDInsight 4.0.

1) Run the script from the cluster:

* For HDInsight 4.0, follow these additional steps:

    a. Additionally, download a helper script used by `exporthive_hdi_4_0.sh`.

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

3) Copy the file `alltables.hql` to the new HDInsight cluster and run the following command:

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

Note: This assumes that data paths on new cluster are same as on old. If not, you can manually edit the generated  
`alltables.hql`  file to reflect any changes. *For ACID tables, a new copy of the data will be created*

Note: This script also assumes that once the script is complete, the old cluster will **not** be used any longer 

#### Further Reading:

1) [Connect to HDInsight Cluster using SSH](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-linux-use-ssh-unix)
