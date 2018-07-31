### Spark Streaming app driver log filled with Error NativeAzureFileSystem ... RequestBodyTooLarge
 
### Issue:
Long running Spark Streaming app driver log filled with Error NativeAzureFileSystem ... RequestBodyTooLarge
 
### Background:
Currently at Spark 2.3, each Spark app generates 1 Spark event log file. The Spark event log file for a Spark Streaming app will continue to grow. If your default storage is WASB, then you'll probably hit file length limit on WASB. 

Today a file on WASB has a 50000 block limit, and the default block size is 4MB. So in default configuration the max file size is 195GB. However, Azure storage has increased the max block size to 100MB, which effectively brought the single file limit to 4.75TB:
https://docs.microsoft.com/en-us/azure/storage/common/storage-scalability-targets

### Investigation Steps:

1. Verified that the cluster configuration does not change this default value of 4MB block size to something smaller. Open Ambari UI, go to HDFS and search for configuration "fs.azure.write.request.size". If not found, you are using the default which is 4MB.

2. Verify that a successful spark event log files (from different run) have 4MB blocks. You can use "Microsoft AzureStorage Explorer". Right click on a container, click on "Get Shared Access Signature...", then copy the query string, something like this:

?st=2018-07-26T18%3A56%3A00Z&se=2018-07-27T18%3A56%3A00Z&sp=rl&sv=2017-04-17&sr=c&sig=PTygmhqZDPAwzqYTDgRRsHWQAF58kzyYIv1RI0w%2FnO0%3D

Then use it to query Azure storage REST API to find out block list, by appending "&comp=blocklist" to the end of the string, something like this:
https://xxx.blob.core.windows.net/yyy-2018-03-20t18-34-42-951z/hdp/spark2-events/application_1521571372955_0001.inprogress?st=2018-07-26T18%3A56%3A00Z&se=2018-07-27T18%3A56%3A00Z&sp=rl&sv=2017-04-17&sr=c&sig=PTygmhqZDPAwzqYTDgRRsHWQAF58kzyYIv1RI0w%2FnO0%3D&comp=blocklist

4. If the block other than the last one is not 4MB, that means either it is a WASB driver bug, or the application set a different block size in configuration for the Spark Streaming app.
 
### Workarounds:
1. Increase the block size to up to 100MB. In Ambari UI, modify HDFS configuration "fs.azure.write.request.size" (or create it in "Custom core-site" section) to somethign bigger, e.g.: 33554432, then save it and restart affected components.

2. Periodically stop and resubmit the spark-streaming job. 

3. Use HDFS to store spark event logs

Disclaimer: use HDFS may results in loss of spark events data in the event of cluster scaling or rarely during Azure upgrades.

a) Make changes to spark.eventlog.dir and spark.history.fs.logDirectory via Ambari UI:
spark.eventlog.dir = hdfs://mycluster/hdp/spark2-events
spark.history.fs.logDirectory = "hdfs://mycluster/hdp/spark2-events"

b) Create directories on HDFS:
hadoop fs -mkdir -p hdfs://mycluster/hdp/spark2-events
hadoop fs -chown -R spark:hadoop hdfs://mycluster/hdp
hadoop fs -chmod -R 777 hdfs://mycluster/hdp/spark2-events
hadoop fs -chmod -R o+t hdfs://mycluster/hdp/spark2-events

c) Restart all affected services via Ambari UI.
