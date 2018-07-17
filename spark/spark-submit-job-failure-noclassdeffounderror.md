### Why do spark-submit job failed with NoClassDefFoundError?
 
### Issue:
Customer has a HDInsight Kafka cluster and a Spark cluster. The Spark cluster runs a spark streaming job that reads data from Kafka cluster. The spark streaming job fails if the kafka stream compression is turned on. In this case, the spark streaming yarn app application_1525986016285_0193 failed, due to error:
~~~~
18/05/17 20:01:33 WARN YarnAllocator: Container marked as failed: container_e25_1525986016285_0193_01_000032 on host: wn87-Scaled.2ajnsmlgqdsutaqydyzfzii3le.cx.internal.cloudapp.net. Exit status: 50. Diagnostics: Exception from container-launch.
Container id: container_e25_1525986016285_0193_01_000032
Exit code: 50
Stack trace: ExitCodeException exitCode=50: 
 at org.apache.hadoop.util.Shell.runCommand(Shell.java:944)
~~~~

### Investigation Steps:
 
1. Note that for Spark, the possible Yarn container exit codes are:
https://stackoverflow.com/questions/45428145/do-exit-codes-and-exit-statuses-mean-anything-in-spark?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa

Exitcode 50 means: The default uncaught exception handler was reached

2. Check Yarn AM logs and container logs:

One of the failed executor container is container_e25_1525986016285_0193_01_000032:

~~~~
18/05/17 20:01:32 ERROR SparkUncaughtExceptionHandler: Uncaught exception in thread Thread[stdout writer for /usr/bin/anaconda/bin/python,5,main]
java.lang.NoClassDefFoundError: org/apache/kafka/common/message/KafkaLZ4BlockOutputStream
	at kafka.message.ByteBufferMessageSet$.decompress(ByteBufferMessageSet.scala:65)
	at kafka.message.ByteBufferMessageSet$$anon$1.makeNextOuter(ByteBufferMessageSet.scala:179)
	at kafka.message.ByteBufferMessageSet$$anon$1.makeNext(ByteBufferMessageSet.scala:192)
	at kafka.message.ByteBufferMessageSet$$anon$1.makeNext(ByteBufferMessageSet.scala:146)
	at kafka.utils.IteratorTemplate.maybeComputeNext(IteratorTemplate.scala:66)
	at kafka.utils.IteratorTemplate.hasNext(IteratorTemplate.scala:58)
	at scala.collection.Iterator$$anon$18.hasNext(Iterator.scala:764)
	at org.apache.spark.streaming.kafka.KafkaRDD$KafkaRDDIterator.getNext(KafkaRDD.scala:214)
	at org.apache.spark.util.NextIterator.hasNext(NextIterator.scala:73)
	at scala.collection.Iterator$class.foreach(Iterator.scala:893)
	at org.apache.spark.util.NextIterator.foreach(NextIterator.scala:21)
	at org.apache.spark.api.python.PythonRDD$.writeIteratorToStream(PythonRDD.scala:504)
	at org.apache.spark.api.python.PythonRunner$WriterThread$$anonfun$run$3.apply(PythonRDD.scala:328)
	at org.apache.spark.util.Utils$.logUncaughtExceptions(Utils.scala:1963)
	at org.apache.spark.api.python.PythonRunner$WriterThread.run(PythonRDD.scala:269)
Caused by: java.lang.ClassNotFoundException: org.apache.kafka.common.message.KafkaLZ4BlockOutputStream
	at java.net.URLClassLoader.findClass(URLClassLoader.java:381)
	at java.lang.ClassLoader.loadClass(ClassLoader.java:424)
	at java.lang.ClassLoader.loadClass(ClassLoader.java:357)
	... 15 more
~~~~

3. Further investiment. Check the spark-submit command, it is something like this:

~~~~
spark-submit \
--packages org.apache.spark:spark-streaming-kafka-0-8_2.11:2.2.0
--conf spark.executor.instances=16 \
...
~/Kafka_Spark_SQL.py <bootstrap server details>
~~~~

Note that the spark-submit command specifies packages for spark-streaming-kafka package, but didn't specify maven repo, and the default repo is maven central. Note that the Kafka cluster they are using has kafka 0.10.1.

### Root Cause:
Customer uses spark-submit command with --packages option but specified wrong version of spark-streaming-kafka jars, one needs to use the matching kafka versioned spark-streaming-kafka jars.


