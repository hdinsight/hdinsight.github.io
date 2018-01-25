
#### Issue : Livy Server was down in HDInsight Spark Production Cluster [(Spark 2.1 on Linux (HDI 3.6)]
#### Attempting to restart results in the following error stack.
##### Found the following entries in the latest livy Logs 
~~~~
 17/07/27 17:52:50 INFO CuratorFrameworkImpl: Starting
 17/07/27 17:52:50 INFO ZooKeeper: Client environment:zookeeper.version=3.4.6-29--1, built on 05/15/2017 17:55 GMT
 17/07/27 17:52:50 INFO ZooKeeper: Client environment:host.name=10.0.0.66
 17/07/27 17:52:50 INFO ZooKeeper: Client environment:java.version=1.8.0_131
 17/07/27 17:52:50 INFO ZooKeeper: Client environment:java.vendor=Oracle Corporation
 17/07/27 17:52:50 INFO ZooKeeper: Client environment:java.home=/usr/lib/jvm/java-8-openjdk-amd64/jre
 17/07/27 17:52:50 INFO ZooKeeper: Client environment:java.class.path= <DELETED>
 17/07/27 17:52:50 INFO ZooKeeper: Client environment:java.library.path= <DELETED>
 17/07/27 17:52:50 INFO ZooKeeper: Client environment:java.io.tmpdir=/tmp
 17/07/27 17:52:50 INFO ZooKeeper: Client environment:java.compiler=<NA>
 17/07/27 17:52:50 INFO ZooKeeper: Client environment:os.name=Linux
 17/07/27 17:52:50 INFO ZooKeeper: Client environment:os.arch=amd64
 17/07/27 17:52:50 INFO ZooKeeper: Client environment:os.version=4.4.0-81-generic
 17/07/27 17:52:50 INFO ZooKeeper: Client environment:user.name=livy
 17/07/27 17:52:50 INFO ZooKeeper: Client environment:user.home=/home/livy
 17/07/27 17:52:50 INFO ZooKeeper: Client environment:user.dir=/home/livy
 17/07/27 17:52:50 INFO ZooKeeper: Initiating client connection, connectString=zk2-kcspark.cxtzifsbseee1genzixf44zzga.gx.internal.cloudapp.net:2181,zk3-kcspark.cxtzifsbseee1genzixf44zzga.gx.internal.cloudapp.net:2181,zk6-kcspark.cxtzifsbseee1genzixf44zzga.gx.internal.cloudapp.net:2181 sessionTimeout=60000 watcher=org.apache.curator.ConnectionState@25fb8912
 17/07/27 17:52:50 INFO StateStore$: Using ZooKeeperStateStore for recovery.
 17/07/27 17:52:50 INFO ClientCnxn: Opening socket connection to server 10.0.0.61/10.0.0.61:2181. Will not attempt to authenticate using SASL (unknown error)
 17/07/27 17:52:50 INFO ClientCnxn: Socket connection established to 10.0.0.61/10.0.0.61:2181, initiating session
 17/07/27 17:52:50 INFO ClientCnxn: Session establishment complete on server 10.0.0.61/10.0.0.61:2181, sessionid = 0x25d666f311d00b3, negotiated timeout = 60000
 17/07/27 17:52:50 INFO ConnectionStateManager: State change: CONNECTED
 17/07/27 17:52:50 WARN NativeCodeLoader: Unable to load native-hadoop library for your platform... using builtin-java classes where applicable
 17/07/27 17:52:50 INFO AHSProxy: Connecting to Application History server at headnodehost/10.0.0.67:10200
 Exception in thread "main" java.lang.OutOfMemoryError: unable to create new native thread
  at java.lang.Thread.start0(Native Method)
  at java.lang.Thread.start(Thread.java:717)
  at com.cloudera.livy.Utils$.startDaemonThread(Utils.scala:98)
  at com.cloudera.livy.utils.SparkYarnApp.<init>(SparkYarnApp.scala:232)
  at com.cloudera.livy.utils.SparkApp$.create(SparkApp.scala:93)
  at com.cloudera.livy.server.batch.BatchSession$$anonfun$recover$2$$anonfun$apply$4.apply(BatchSession.scala:117)
  at com.cloudera.livy.server.batch.BatchSession$$anonfun$recover$2$$anonfun$apply$4.apply(BatchSession.scala:116)
  at com.cloudera.livy.server.batch.BatchSession.<init>(BatchSession.scala:137)
  at com.cloudera.livy.server.batch.BatchSession$.recover(BatchSession.scala:108)
  at com.cloudera.livy.sessions.BatchSessionManager$$anonfun$$init$$1.apply(SessionManager.scala:47)
  at com.cloudera.livy.sessions.BatchSessionManager$$anonfun$$init$$1.apply(SessionManager.scala:47)
  at scala.collection.TraversableLike$$anonfun$map$1.apply(TraversableLike.scala:244)
  at scala.collection.TraversableLike$$anonfun$map$1.apply(TraversableLike.scala:244)
  at scala.collection.mutable.ResizableArray$class.foreach(ResizableArray.scala:59)
  at scala.collection.mutable.ArrayBuffer.foreach(ArrayBuffer.scala:47)
  at scala.collection.TraversableLike$class.map(TraversableLike.scala:244)
  at scala.collection.AbstractTraversable.map(Traversable.scala:105)
  at com.cloudera.livy.sessions.SessionManager.com$cloudera$livy$sessions$SessionManager$$recover(SessionManager.scala:150)
  at com.cloudera.livy.sessions.SessionManager$$anonfun$1.apply(SessionManager.scala:82)
  at com.cloudera.livy.sessions.SessionManager$$anonfun$1.apply(SessionManager.scala:82)
  at scala.Option.getOrElse(Option.scala:120)
  at com.cloudera.livy.sessions.SessionManager.<init>(SessionManager.scala:82)
  at com.cloudera.livy.sessions.BatchSessionManager.<init>(SessionManager.scala:42)
  at com.cloudera.livy.server.LivyServer.start(LivyServer.scala:99)
  at com.cloudera.livy.server.LivyServer$.main(LivyServer.scala:302)
  at com.cloudera.livy.server.LivyServer.main(LivyServer.scala)
  
  ## using "vmstat" found for free memory on the server, we had enough free memory
~~~~

java.lang.OutOfMemoryError: unable to create new native thread highlights; highlights OS cannot assign more native threads to JVMs
Confirmed that this Exception is caused by the violation of the per-process thread count limit

Looking at Livy implementation we found that livy will save the session state in ZK (in HDInsight) and recover those sessions on restart. When restarting, livy will create a thread for each session. 

This is part of High Availability for LivyServer
refer section High Availability under https://hortonworks.com/blog/livy-a-rest-interface-for-apache-spark/
In case if Livy Server fails, all the connections to  Spark Clusters are also terminated, which means that all the jobs and related data will be lost.
As a session recovery mechanism Livy stores the session details in Zookeeper to be recovered after the livy Server is back.


In this scenario we found customer had submitted a large number of jobs to livy. So it accumulated a certain amount of to-be-recovered sessions causing too many threads being created.

##### Mitigation: Delete all entries using steps detailed below.

- Get the IP address of the zookeeper Nodes using 
~~~~  
grep -R zk /etc/hadoop/conf  
~~~~

- Above command listed all the zookeepers for my cluster 

~~~~
    /etc/hadoop/conf/core-site.xml:      <value>zk1-hwxspa.lnuwp5akw5ie1j2gi2amtuuimc.dx.internal.cloudapp.net:2181,zk2-      hwxspa.lnuwp5akw5ie1j2gi2amtuuimc.dx.internal.cloudapp.net:2181,zk4-hwxspa.lnuwp5akw5ie1j2gi2amtuuimc.dx.internal.cloudapp.net:2181</value>
~~~~
- Get all the IP address of the zookeeper nodes using ping Or you can also connect to zookeeper from headnode using zk name 

~~~~  
/usr/hdp/current/zookeeper-client/bin/zkCli.sh -server zk2-hwxspa:2181   
~~~~
##### Once you are connected to zookeeper execute the following command to list all the session that are attempted to restart. ####
##### Most of the cases this could be a list more than 8000 sessions ####
~~~~  
ls /livy/v1/batch  
~~~~

##### Following command is to remove all the to-be-recovered sessions. #####
~~~~  
rmr /livy/v1/batch  
~~~~
##### Wait for the above command to complete and the cursor to return the prompt and then restart livy service from ambari which should succeed. 
##### Note: Deleting the session maintained under zookeeper is a workaround.
### Recommended solution would be to delete the livy session once it is completed its execution.

##### Continue reading for some more details that was explored while troubleshooting this issue
ADF uses livy server to submit job, scheduled a python job to be processed part of pipleline every 15 minutes. Tracked the zookeeper entries to find the session were not getting for more than 12 hours. Looking at the state of the session set to dead, they should have been Garbage collected which is not happening.

~~~~ 

{"from":0,"total":23,"sessions":[{"id":11,"state":"dead","appId":"application_1515528956848_0019","appInfo":{"driverLogUrl":null,"sparkUiUrl":"https://sparkhdi.azurehdinsight.net/yarnui/hn/proxy/application_1515528956848_0019/"},"log":["YARN Diagnostics:","User application exited with status 1"]},{"id":12,"state":"dead","appId":"application_1515528956848_0020","appInfo":{"driverLogUrl":null,"sparkUiUrl":"https://sparkhdi.azurehdinsight.net/yarnui/hn/proxy/application_1515528956848_0020/"},"log":["YARN Diagnostics:","User application exited with status 1"]},{"id":13,"state":"dead","appId":"application_1515528956848_0021","appInfo":{"driverLogUrl":null,"sparkUiUrl":"https://sparkhdi.azurehdinsight.net/yarnui/hn/proxy/application_1515528956848_0021/"},"log":["YARN Diagnostics:","User application exited with status 1"]}

~~~~

The default timeout was around an hour thought that was interactive session.  Only other session timeout value that is livy.server.session.timeout = 2073600000.
For testing set the livy.server.session.timeout to 36900000 found the session entries were garbage collected after about 1 hour 10 minutes.
Looking at the following snip of code livy would be the max of the default timeout and the session.timeout set on ambari.

~~~~
  def collectGarbage(): Future[Iterable[Unit]] = {
    def expired(session: Session): Boolean = {
      val currentTime = System.nanoTime()
      currentTime - session.lastActivity > math.max(sessionTimeout, session.timeout)
    }
    Future.sequence(all().filter(expired).map(delete))
  }
~~~~
