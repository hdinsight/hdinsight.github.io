| title  | description  | keywords  | services  |  documentationcenter | author  | manager  | editor  | ms.assetid  | ms.service  | ms.workload  | ms.tgt_pltfrm  | ms.devlang  | ms.topic  | ms.date  | ms.author  |
|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|---|
|Both ResourceManger stuck in standby mode? Microsoft Docs  |  | Azure HDInsight, Yarn, Resource Manger, stadnby mode, wasb, adls, abfs.  |  Azure HDInsight  | na  | marshall  | shravan  |  marshall | na  | multiple  | na  | na  | na  | article  | 12/09/2019  |  zhaya |
  
---

# Both RM in standby mode?

You can check the /var/log/hadoop-yarn/yarn/yarn-yarn-resourcemanager.log from both headnodes. If both headnode are saying
can not transit to active that means you're in the right TSG. Reason mentioning this is because, 
can not transit to active node is expected log if the other RM is taking the active role.

# What is the reason behind that?

We've seen several ICMs about the standy mode issue. All of them are due to the node-label.mirror file missing from HDFS issue. We introduced
node-label recently which is using the hdfs to maintain the node-label store. However, during the scale down event, this file might lost. 
HDFS would reject all the request until this missing block is recovered. 

# What is the fix?

We are working on a fix to use remote storage account instead of local hdfs to maintain the node-label mirror, which might take a while
to test with all the storage types.

# What is the mitigation?

You can check 
```
$ hdfs fsck hdfs://mycluster/
```
if it says some files are under replica, or there're missing blocks in hdfs.
You can run 
```
$ hdfs fsck hdfs://mycluster/ -delete
```
to forcefully clean up the hdfs.
After this you should be able to get rid of the standby RM issue.
