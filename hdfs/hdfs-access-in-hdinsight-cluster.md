---
title: How do I access local HDFS from inside HDInsight cluster? | Microsoft Docs
description: Use the HDFS FAQ for answers to common questions on HDFS on Azure HDInsight platform.
keywords: Azure HDInsight, HDFS, FAQ, troubleshooting guide, common problems, local access
services: Azure HDInsight
documentationcenter: na
author: arijitt
manager: ''
editor: ''

ms.assetid: 4C33828F-2982-47F0-B858-C32FFF634D9E
ms.service: multiple
ms.workload: na
ms.tgt_pltfrm: na
ms.devlang: na
ms.topic: article
ms.date: 04/05/2017
ms.author: arijitt
---

### How do I access local HDFS from inside HDInsight cluster?

#### Issue:

Need to access local HDFS instead of WASB or ADLS from inside HDInsight cluster.   

#### Resolution Steps:

1. From command line use `hdfs dfs -D "fs.default.name=hdfs://mycluster/" ...` literally as in the following command:

~~~
hdiuser@hn0-spark2:~$ hdfs dfs -D "fs.default.name=hdfs://mycluster/" -ls /
Found 3 items
drwxr-xr-x   - hdiuser hdfs          0 2017-03-24 14:12 /EventCheckpoint-30-8-24-11102016-01
drwx-wx-wx   - hive    hdfs          0 2016-11-10 18:42 /tmp
drwx------   - hdiuser hdfs          0 2016-11-10 22:22 /user
~~~

2. From source code use the URI `hdfs://mycluster/` literally as in the following sample application:

~~~
import java.io.IOException;
import java.net.URI;
import org.apache.commons.io.IOUtils;
import org.apache.hadoop.conf.Configuration;
import org.apache.hadoop.fs.*;

public class JavaUnitTests {

    public static void main(String[] args) throws Exception {

        Configuration conf = new Configuration();

        String hdfsUri = "hdfs://mycluster/";

        conf.set("fs.defaultFS", hdfsUri);

        FileSystem fileSystem = FileSystem.get(URI.create(hdfsUri), conf);

        RemoteIterator<LocatedFileStatus> fileStatusIterator = fileSystem.listFiles(new Path("/tmp"), true);

        while(fileStatusIterator.hasNext()) {

            System.out.println(fileStatusIterator.next().getPath().toString());
        }
    }
}
~~~

Run the compiled JAR (for example named `java-unit-tests-1.0.jar`) on HDInsight cluster with the following command:

~~~
hdiuser@hn0-spark2:~$ hadoop jar java-unit-tests-1.0.jar JavaUnitTests
hdfs://mycluster/tmp/hive/hive/5d9cf301-2503-48c7-9963-923fb5ef79a7/inuse.info
hdfs://mycluster/tmp/hive/hive/5d9cf301-2503-48c7-9963-923fb5ef79a7/inuse.lck
hdfs://mycluster/tmp/hive/hive/a0be04ea-ae01-4cc4-b56d-f263baf2e314/inuse.info
hdfs://mycluster/tmp/hive/hive/a0be04ea-ae01-4cc4-b56d-f263baf2e314/inuse.lck
~~~