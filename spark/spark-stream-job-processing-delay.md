### Why did my Spark Streaming jobs take longer than usual to process?
 
### Issue:
Some of the HDInsight Spark Streaming jobs is slow, and it took longer than usual to process. For Spark Streaming applications, each batch of messages corresponds to one job submitted to Spark. Usually a job took X seconds to process, but occasionally a Spark job took 2-3 minutes more than usual times.
 
### Investigation Steps:
 
1. Understand user's streaming setup.

Where is the data coming from and where does the data go? Let say the streaming app get data from EventHubs, and write to Kafka.

2. Get access to Spark UI.

This can be done from Yarn UI of the Spark application, then click on "ApplicationMaster" link.
    https://<clustername>.azurehdinsight.net/yarnui

3. Find the tasks that slowed the job. 

First find the job that is slower than normal, then sort all the tasks of this job by "duration" in descending order. You will find one or a few tasks that took much longer than other tasks. In some cases if the streaming app turned on speculation (spark.speculation), you'll see some failed tasks (more below).

4. Get Yarn AM container logs (where the Spark driver runs) for the app. 

You can go to "Executors" tab in Spark UI to find out driver's container ID. Spark UI has links to container log for the driver, however, currently these links are broken. While we are working to fix these links, we can manually retrieve container logs like this: click on the "stderr" link, find out the container ID, then ssh to the cluster headnode, run command:
~~~~
yarn logs -applicationId <application-id> -containerId <container-id>
~~~~

For tasks killed due to Spark speculation, you'll see something like this in AM log (these are benign messages, not an indication of problems):
~~~~
18/05/17 22:06:19 INFO TaskSetManager: Starting task 349.1 in stage 1.0 (TID 2017, wn2-cus-te.irhcfv1m2odevp2sycmcl3el4c.gx.internal.cloudapp.net, executor 12, partition 349, PROCESS_LOCAL, 6438 bytes)
18/05/17 22:06:20 INFO TaskSetManager: Killing attempt 0 for task 349.0 in stage 1.0 (TID 365) on wn4-cus-te.irhcfv1m2odevp2sycmcl3el4c.gx.internal.cloudapp.net as the attempt 1 succeeded on wn2-cus-te.irhcfv1m2odevp2sycmcl3el4c.gx.internal.cloudapp.net
18/05/17 22:06:20 INFO TaskSetManager: Finished task 349.1 in stage 1.0 (TID 2017) in 1180 ms on wn2-cus-te.irhcfv1m2odevp2sycmcl3el4c.gx.internal.cloudapp.net (executor 12) (1998/2000)
~~~~

5.Get Yarn container logs for the executor that runs the task to see if there are any problems.

Follow the above steps to get container logs for each the problematic task.

You can use the "ID" column of the tasks table in Spark UI to search for the task in Yarn container log. E.g. "TID 365". For the failed tasks due to Spark speculation, you may find error like this (these are benign messages, not an indication of problems):
~~~~
org.apache.spark.SparkException: Error communicating with MapOutputTracker
	at org.apache.spark.MapOutputTracker.askTracker(MapOutputTracker.scala:106)
	at org.apache.spark.MapOutputTracker.getStatuses(MapOutputTracker.scala:204)
at org.apache.spark.MapOutputTracker.getMapSizesByExecutorId(MapOutputTracker.scala:144)
~~~~

For the slow task, you can check the logs to figure out where is the time spent. In this case, we found that there are a 2 minutes gap in the logs:
~~~~
18/05/21 14:43:01 INFO Executor: Finished task 766.0 in stage 5089.0 (TID 2585693). 1477 bytes result sent to driver
18/05/21 14:43:02 INFO KafkaProducer: [Producer clientId=producer-85445] Closing the Kafka producer with timeoutMillis = 9223372036854775807 ms.
18/05/21 14:43:02 INFO Executor: Finished task 896.0 in stage 5089.0 (TID 2585823). 1477 bytes result sent to driver
18/05/21 14:45:03 INFO KafkaProducer: [Producer clientId=producer-85435] Closing the Kafka producer with timeoutMillis = 9223372036854775807 ms.

~~~~

This is an indication that the problem happens during writing message to external Kafka cluster using the KafkaProducer class.

### Root Cause:
The Kafka producer took more than 2 minutes to finish writing out to Kafka cluster. To further debugging the Kafka issue, you can add some logs to the code that uses Kafka producer to send out messages, and correlate that with the logs from Kafka cluster.

