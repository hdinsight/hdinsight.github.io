## Unable to launch Spark Application part of oozie workflow using Oozie Shell Action.

### Scenario:
Spark Applications that are part of oozie workflow using Oozie Shell Action will fail to launch with one of the following expections on **Spark 2.1+ clusters**and without spark 1.6. Same Spark Application would work complete successfully when launced using the spark-submit.

Exceptions: One of these exception will be shown. 
- Exception in thread "main" java.lang.NoSuchMethodError:
- Multiple versions of Spark are installed but SPARK_MAJOR_VERSION is not set
- 	Spark1 will be picked by default
- java.lang.ClassNotFoundException: org.apache.spark.sql.SparkSession

Analyze the logs to find the Oozie was trying to launch Spark 1.+ jars instead of spark 2.1 jars. 
Following line is from the YARN logs under the “directory.info” section:

lrwxrwxrwx 1 yarn hadoop  118 Sep 13 15:36 __spark__.jar -> /mnt/resource/hadoop/yarn/local/usercache/yarn/filecache/12/spark-assembly-1.6.3.2.6.1.10-4-hadoop2.7.3.2.6.1.10-4.jar

It appears that when Oozie ran “spark-submit”, it linked the Spark 1.6.3 jar

Spark Applications submitted using Oozie shell action does not honor SPARK_HOME=/usr/hdp/current/spark2-client and SPARK_MAJOR_VERSION=2 environment variables.

### Recommended changes:

- Use the complete path for the spark-submit in the Workflow like this

<exec>/usr/hdp/current/spark2-client/bin/spark-submit</exec>
Instead of 
<exec>$SPARK_HOME/bin/spark-submit</exec>

And

- Add the following to the workflow just before the end tag </shell>

<env-var>SPARK_MAJOR_VERSION=2</env-var>

