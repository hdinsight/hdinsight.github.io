
Symptoms 

1. Any spark application submitted via Spark-Submit would complete the job execution but the **spark-submit would just hang**.
2. Spark Jobs deployed triggers huge amount of logging events (MdsLogger).

Steps to Reproduce the issue.

*    Create a Spark Cluster 2.2. or 2.3
*    Execute a sample Spark Application
*        spark-submit --master yarn --deploy-mode cluster --class SparkCore_WasbIOTest default_artifact.jar

Find the job executed, finished successfully but the spark-submit would just hand and **will not exit followed by MdsLgger entries**.

```
         final status: SUCCEEDED
         tracking URL: http://hn0-kcspar.ep4xvfyigrfefcencs2sajxuta.dx.internal.cloudapp.net:8088/proxy/application_1530566316498_0004/
         user: sshuser
16: MdsLogger offer successful = true
16: MdsLogger offer successful = true
15: took mesage out of queue: {"DATA":["1530566749956","azureFileSystem","azureFileSystem","815fa42f-b859-40ca-a6ec-074668a96448","323043","0","15005294","0","{wasb_raw_bytes_uploaded=323043, wasb_maximum_upload_bytes_per_second=15005294, wasb_raw_bytes_uploaded_delta=323043, wasb_web_responses_delta=82, wasb_web_responses=82, wasb_files_created=2, wasb_directories_created=1}"],"SOURCE":"wasb-metrics","TAG":"WasbAzureIaasSink-d4252ddf-3cd9-4fa2-ba98-cb4cd87f2b7d"}
15: message written to socket.
15: took mesage out of queue: {"DATA":["1530566749975","azureFileSystem","azureFileSystem","023cdfb9-5e69-48c8-a435-081ad35fdfb6","0","0","0","0","{wasb_web_responses_delta=5, wasb_web_responses=5}"],"SOURCE":"wasb-metrics","TAG":"WasbAzureIaasSink-a1ba5cf1-748a-4002-b1c7-dd828b56a71e"}
15: message written to socket.
16: MdsLogger offer successful = true
15:message written to socket.

```
3. Other Symptoms observed : All Spark and related services would displace High CPU usage
Here is snip from top command for my cluster

```
top - 21:29:34 up 17 min,  2 users,  load average: 7.72, 8.35, 5.57
Tasks: 208 total,   1 running, 143 sleeping,   0 stopped,   0 zombie
%Cpu(s): 95.8 us,  4.1 sy,  0.0 ni,  0.0 id,  0.0 wa,  0.0 hi,  0.1 si,  0.0 st
KiB Mem : 28789328 total, 18887372 free,  7561064 used,  2340892 buff/cache
KiB Swap:  7340028 total,  7340028 free,        0 used. 20501148 avail Mem

   PID USER      PR  NI    VIRT    RES    SHR S  %CPU %MEM     TIME+ COMMAND
 21509 hive      20   0 10.786g 644656  37032 S 282.1  2.2  21:00.27 java
 21906 spark     20   0 4585648 286712  37032 S  89.7  1.0   7:14.50 java
 15012 yarn      20   0 2999084 474640  29516 S   3.0  1.6   0:42.88 java
 17277 hive      20   0 12.518g 604760  37260 S   2.3  2.1   0:38.16 java
 19248 hdfs      20   0 2925236 416292  29260 S   2.3  1.4   0:31.70 java
 21054 livy      20   0 5670176 305104  34576 S   2.3  1.1   0:21.18 java
```

Resolution: 
*    Execute following command on hn0 & hn1 to create a soft link, that points to the right jar file. This command would resolve the Spark-Submit hang issue.  But continue with the next step to resolve the high CPU issue. 
```
sudo ln -sf /usr/lib/hdinsight-logging/mdsdclient-1.0.jar $SPARK_HOME/jars/mdsdclient-1.jar
```
*    Restart all Spark and related services like Thrift server, Livy etc through Ambari, after the services restart you should not see high CPU utilization.
