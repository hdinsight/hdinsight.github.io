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
for d in `beeline -u "jdbc:hive2://localhost:10001/;transportMode=http" --showHeader=false --silent=true --outputformat=tsv2 -e "show databases;"`; 
do
    echo "Scanning Database: $d"
    echo "create database if not exists $d; use $d;" >> alltables.hql; 
    for t in `beeline -u "jdbc:hive2://localhost:10001/$d;transportMode=http" --showHeader=false --silent=true --outputformat=tsv2 -e "show tables;"`;
    do
        echo "Copying Table: $t"
        ddl=`beeline -u "jdbc:hive2://localhost:10001/$d;transportMode=http" --showHeader=false --silent=true --outputformat=tsv2 -e "show create table $t;"`;

        echo "$ddl;" >> alltables.hql;
        lowerddl=$(echo $ddl | awk '{print tolower($0)}')
        if [[ $lowerddl == *"'transactional'='true'"* ]]; then
            if [[ $lowerddl == *"partitioned by"* ]]; then
                # partitioned
                raw_cols=$(beeline -u "jdbc:hive2://localhost:10001/$d;transportMode=http" --showHeader=false --silent=true --outputformat=tsv2 -e "show create table $t;" | tr '\n' ' ' | grep -io "CREATE TABLE .*" | cut -d"(" -f2- | cut -f1 -d")" | sed 's/`//g');
                ptn_cols=$(beeline -u "jdbc:hive2://localhost:10001/$d;transportMode=http" --showHeader=false --silent=true --outputformat=tsv2 -e "show create table $t;" | tr '\n' ' ' | grep -io "PARTITIONED BY .*" | cut -f1 -d")" | cut -d"(" -f2- | sed 's/`//g');
                final_cols=$(echo "(" $raw_cols "," $ptn_cols ")")

                beeline -u "jdbc:hive2://localhost:10001/$d;transportMode=http" --showHeader=false --silent=true --outputformat=tsv2 -e "create external table ext_$t $final_cols TBLPROPERTIES ('transactional'='false');";
                beeline -u "jdbc:hive2://localhost:10001/$d;transportMode=http" --showHeader=false --silent=true --outputformat=tsv2 -e "insert into ext_$t select * from $t;";
                staging_ddl=`beeline -u "jdbc:hive2://localhost:10001/$d;transportMode=http" --showHeader=false --silent=true --outputformat=tsv2 -e "show create table ext_$t;"`;
                dir=$(echo $staging_ddl | grep -io " LOCATION .*" | grep -m1 -o "'.*" | sed "s/'[^-]*//2g" | cut -c2-);

                parsed_ptn_cols=$(echo $ptn_cols| sed 's/ [a-z]*,/,/g' | sed '$s/\w*$//g');
                echo "create table flattened_$t $final_cols;" >> alltables.hql;
                echo "load data inpath '$dir' into table flattened_$t;" >> alltables.hql;
                echo "insert into $t partition($parsed_ptn_cols) select * from flattened_$t;" >> alltables.hql;
                echo "drop table flattened_$t;" >> alltables.hql;
                beeline -u "jdbc:hive2://localhost:10001/$d;transportMode=http" --showHeader=false --silent=true --outputformat=tsv2 -e "drop table ext_$t";
            else
                # not partitioned
                beeline -u "jdbc:hive2://localhost:10001/$d;transportMode=http" --showHeader=false --silent=true --outputformat=tsv2 -e "create external table ext_$t like $t TBLPROPERTIES ('transactional'='false');";
                staging_ddl=`beeline -u "jdbc:hive2://localhost:10001/$d;transportMode=http" --showHeader=false --silent=true --outputformat=tsv2 -e "show create table ext_$t;"`;
                dir=$(echo $staging_ddl | grep -io " LOCATION .*" | grep -m1 -o "'.*" | sed "s/'[^-]*//2g" | cut -c2-);

                beeline -u "jdbc:hive2://localhost:10001/$d;transportMode=http" --showHeader=false --silent=true --outputformat=tsv2 -e "insert into ext_$t select * from $t;";
                echo "load data inpath '$dir' into table $t;" >> alltables.hql;
                beeline -u "jdbc:hive2://localhost:10001/$d;transportMode=http" --showHeader=false --silent=true --outputformat=tsv2 -e "drop table ext_$t";
            fi
        fi
        echo "$ddl" | grep -q "PARTITIONED\s*BY" && echo "MSCK REPAIR TABLE $t;" >> alltables.hql;
    done;
done
~~~

This will generate a file named `alltables.hql`.

3) Copy the file `alltables.hql` to the new HDInsight cluster and run the following command:

~~~
beeline -u "jdbc:hive2://localhost:10001/;transportMode=http" -f alltables.hql
~~~

Note: This assumes that data paths on new cluster are same as on old. If not, you can manually edit the generated  
`alltables.hql`  file to reflect any changes. *For ACID tables, a new copy of the data will be created*

Note: This script also assumes that once the script is complete, the old cluster will **not** be used any longer 

#### Further Reading:

1) [Connect to HDInsight Cluster using SSH](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-hadoop-linux-use-ssh-unix)
