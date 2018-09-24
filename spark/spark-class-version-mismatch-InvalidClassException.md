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


### Investigation Steps:
 
1. From the stack trace we know that the "InvalidClassException" happens for class "org.apache.commons.lang3.time.FastDateFormat". An online search found that this belongs to commons-lang3 package. In Spark's jar folder we can find this jar:
/usr/hdp/2.6.5.10-2/spark2/jars/commons-lang3-3.5.jar

2. We can ssh to the machine where this problem happens (wn7 in this case), and try to find the jars on the local box:
~~~~
locate commons-lang3
~~~~
We found quite a few of them, but they are in different folders (e.g. hadoop folder). You can create a same version HDI cluster to compare the results. Especially we need to make sure "/usr/hdp/xxx/spark2/jars/" does not contain a different version of the package.

3. Look at Ambari configuration history for "Spark2" component. You can even compare two config versions in Ambari UI.
In this case, we found out that the customer manually added an additonal jar to "spark.yarn.jars" config:
adl:///user/xxx/AzureLogAppender-1.0.jar
You can download this jar and decompose it, which contains a different version of the "FastDateFormat" class.
Further investigation reveals that the AzureLogAppender project (can be found in github) indeed depends on the Azure API library which depends on a different version of commons-lang3 library.

### Root Cause:
Customer added an additional jar to "spark.yarn.jars" config, which is a shaded jar that includes a different version of commons-lang3 package (Spark 2.1/2/3 uses version 3.5).

### Workaround
Customer either need to remove the jar, or they need to recompile the customized jar (AzureLogAppender) and use maven-shade-plugin to relocate classes:
http://maven.apache.org/plugins/maven-shade-plugin/examples/class-relocation.html

