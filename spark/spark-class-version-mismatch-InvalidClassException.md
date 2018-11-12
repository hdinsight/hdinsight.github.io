---
title: Azure HDInsight Solutions | Apache Spark | Spark job fails with InvalidClassException
description: Learn how to resolve InvalidClassException for Apache Spark jobs.
services: hdinsight
author: confusionblinds
ms.author: sunilkc
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: 11/12/2018
---

# Azure HDInsight Solutions | Apache Spark | Spark job fails with InvalidClassException

## Scenario: Spark job fails with InvalidClassException

## Issue

You try to create a Spark job in a Spark 2.x cluster. It fails with an error similar to the following:

```java
18/09/18 09:32:26 WARN TaskSetManager: Lost task 0.0 in stage 1.0 (TID 1, wn7-dev-co.2zyfbddadfih0xdq0cdja4g.ax.internal.cloudapp.net, executor 4): java.io.InvalidClassException: 
org.apache.commons.lang3.time.FastDateFormat; local class incompatible: stream classdesc serialVersionUID = 2, local class serialVersionUID = 1
        at java.io.ObjectStreamClass.initNonProxy(ObjectStreamClass.java:699)
        at java.io.ObjectInputStream.readNonProxyDesc(ObjectInputStream.java:1885)
        at java.io.ObjectInputStream.readClassDesc(ObjectInputStream.java:1751)
        at java.io.ObjectInputStream.readOrdinaryObject(ObjectInputStream.java:2042)
        at java.io.ObjectInputStream.readObject0(ObjectInputStream.java:1573) 
```

## Cause

This error can be caused by adding an additional jar to the `spark.yarn.jars` config, which is a "shaded" jar that includes a different version of `commons-lang3` package and introduces a class mismatch. By default, Spark 2.1/2/3 uses version 3.5 of `commons-lang3`.

## Solution

Either remove the jar, or recompile the customized jar (AzureLogAppender) and use [maven-shade-plugin](http://maven.apache.org/plugins/maven-shade-plugin/examples/class-relocation.html) to relocate classes.

---

### Spark job fails with InvalidClassException - class version mismatch
 
### Issue:
Open source software has a common problem of so called "dependency hell". For example, if Spark depends on a particular version of a package, and your Spark job depends on a library that depends on a different version of the same package, then potentially you'll hit problems caused by this class version mismatch.

In this case, the customer cannot load any CSV file in Spark 2.x cluster. The failure message with stack trace:
~~~~
18/09/18 09:32:26 WARN TaskSetManager: Lost task 0.0 in stage 1.0 (TID 1, wn7-dev-co.2zyfbddadfih0xdq0cdja4g.ax.internal.cloudapp.net, executor 4): java.io.InvalidClassException: 
org.apache.commons.lang3.time.FastDateFormat; local class incompatible: stream classdesc serialVersionUID = 2, local class serialVersionUID = 1
        at java.io.ObjectStreamClass.initNonProxy(ObjectStreamClass.java:699)
        at java.io.ObjectInputStream.readNonProxyDesc(ObjectInputStream.java:1885)
        at java.io.ObjectInputStream.readClassDesc(ObjectInputStream.java:1751)
        at java.io.ObjectInputStream.readOrdinaryObject(ObjectInputStream.java:2042)
        at java.io.ObjectInputStream.readObject0(ObjectInputStream.java:1573) 
~~~~
