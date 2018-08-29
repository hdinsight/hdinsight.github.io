Issue: Getting file not found error with a scala app calling RDD.pipe API

Problem description:  R Script can be called from within a scala code as detailed below.

```
val spark = SparkSession
.builder()
.appName("PipeToR")
.getOrCreate()

val sc = spark.sparkContext
val rdd = sc.parallelize(Array("Spark","To","R","Test"))

val distScript = "adl://randomenameadls.azuredatalakestore.net/clusters/clustername/Scripts/rtest.R"
sc.addFile(distScript)

val distScriptName = "rtest.R"
val piped = rdd.pipe(org.apache.spark.SparkFiles.get(distScriptName))

val result = piped.collect
```

Here is what's happening under the hood:

`sc.addFile` call (followed by a RDD action) downloads the file to the driver/executor nodes.
	* For the driver node, the download path is the driver local path, something like "/tmp/spark-11ce1523-8cfb-4525-a6cd-ec65b6591118". 
	* For the executor nodes, the download path is under the spark local path, which is configured by "yarn.nodemanager.local-dirs". 
	* The downloaded path is unique per YARN container, something like "/mnt/resource/hadoop/yarn/local/usercache/sshuser/appcache/application_1528200633357_0006/spark-46a6cb71-1f29-4530-9796-841336bc0691/userFiles-84a15633-6739-452c-a85a-7de2749926c4".

`org.apache.spark.SparkFiles.get(distScriptName)`
	* Returns the path for this script file 
	* If this method is called from the driver, then it's the driver local path; if called from the executors, it should be the container specific path.

`rdd.pipe` call (followed by a RDD action)
	* The input to this method is the file path which will be picked up by executors. 
	* The limitation for this API call is that the file path is being resolved in the driver. 
	* In this scenario, org.apache.spark.SparkFiles.get() was called to resolve the file path which returns the path on the driver node. 
	* However the correct file path for executors should be the container specific path. That's why they are seeing "file not found" error.

Mitigation steps:

Due to the limitation from this pipe() method (i.e. path being resolved in driver process), we have to make sure this script file has the same path across all nodes (e.g. "/home/sshuser/rtest.R").
