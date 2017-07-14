### Why did my Spark Streaming Application stop processing data after executing for 24 days with no known errors in the logs?
 
### Issue:
HDInsight Spark Streaming applications stops after executing for 24 days with no known errors in the log.
 
### Resolution Steps:
 
1. Start from YARN UI to understand when the application execution started and when did it finish, you will also find that the .
2.	Look at the log (yarn application log/node manager log) for that specific job.
3.	From the YARN logs we identified that the application was killed by someone through Livy
~~~~
containermanager.ContainerManagerImpl (ContainerManagerImpl.java:stopContainerInternal(960)) - Stopping container with container Id: container_e03_14960      62938511_0001_01_000001
nodemanager.NMAuditLogger (NMAuditLogger.java:logSuccess(89)) - USER=livy IP=10.95.22.33  OPERATION=Stop Container Request
container.ContainerImpl (ContainerImpl.java:handle(1163)) - Container container_e03_1496062938511_0001_01_000001 transitioned from RUNNING to KILLING
~~~~

4.	Confirm from the YARN logs that the job failed without any resource limitation violation (Primarily Memory), you will see that the application is killed without any errors.
5.	Mostly if the job is killed you might not find the Application status on the Spark UI,  so start looking at the workflow of the job now that the job was submitted using Livy. 
6.	Livy is entry point which is a restful service, it maintains session expiration value.
7.	livy.server.session.timeout is the key set to 2073600000 milliseconds (24 *24 * 60 * 60 *1000) which translates to 24 Days

### Cause:
This livy.server.session.timeout value drives how long Livy should be waiting for an session to be completed and the kills the applications when it reaches the Session.Timeout value.
 
### Resolution:
For a log running jobs increase the value for livy.server.session.timeout using Ambari UI.
You can access Livy configuration from Ambari UI using link [https://YourClusterDnsName.azurehdinsight.net/#/main/services/LIVY/configs]
	replace clusterDnsName with your clusterName

 

