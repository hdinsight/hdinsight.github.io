## This article would help trace a request for Spark application failure that was submitted from Jupyter notebook ##

## We are tracing a Scenario where after Jupyter notebook runs a while, when tried to execute the next cell, the kernel cannot be connected and the Yarn application is dead.

## Investigation Steps:

1. Identify the Spark app for the Jupyter session that got disconnect and from Yarn UI get the Livy session which would be part of application name
Example: Yarn app is: livy-session-483-o46zz6wl and the livy session would be 483

2. Check livy server log for the duration when the app was running, which is:
For this instance found following in the log:
```
18/07/07 19:02:40 INFO InteractiveSessionManager: Session 483 expired. Last heartbeat is at Sat Jul 07 19:01:31 UTC 2018.
18/07/07 19:02:40 INFO InteractiveSession: Stopping InteractiveSession 483...
```

3) Looks like the livy server killed the Yarn application because heartbeat is lost (for about 1 minute, according to the log above). 

4. Next step is to out why the heartbeat is lost.
This is how the calls are connected between the components  on HDinsight:
```
Web client --- HDIGateway --- JupyterServer --- JupyterSparkMagic --- Livy --- YarnApplication
```

5. Look for entries in Jupyter Spark Magic log , check where was the last entry made.

In this scenario noticed that the last message of spark magic log stops at 2018-07-07 19:01:31.4472580, and there was a 33 minutes gap between this message and next message when spark magic got restarted.

```
PreciseTimeStamp	TraceLevel	Message
2018-07-07 19:01:31.4472580	DEBUG	Command	Status of statement 219 is running.
2018-07-07 19:34:27.6362690	DEBUG	SparkMagics	Initialized spark magics.
```
6. Next step look at Jupyter server logs:

looks like the Jupyter server restarted around 19:04 indicated by the jupyter log:
```
PreciseTimeStamp	TraceLevel	Message
[I 2018-07-07 19:01:01.621 NotebookApp] Saving file at /Sprint5/OPLD/Step1_OPLD_Enrichment_MT.ipynb
[JUPYTER_NOTEBOOK_CONFIG] Not configuring content HA
[W 19:04:15.587 NotebookApp] Config option `token` not recognized by `NotebookApp`.
[W 2018-07-07 19:04:15.745 NotebookApp] WARNING: The notebook server is listening on all IP addresses and not using encryption. This is not recommended.
[W 2018-07-07 19:04:15.745 NotebookApp] WARNING: The notebook server is listening on all IP addresses and not using authentication. This is highly insecure and not recommended.
[I 2018-07-07 19:04:15.752 NotebookApp] Serving notebooks from local directory: /var/lib/jupyter
[I 2018-07-07 19:04:15.752 NotebookApp] 0 active kernels
[I 2018-07-07 19:04:15.752 NotebookApp] The Jupyter Notebook is running at: http://[all ip addresses on your system]:8001/
[I 2018-07-07 19:04:15.752 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
```
Also verified that if spark magic process (a python process) died, Jupyter server will restart it. So the problem seems to be caused by Jupyter server problem. Now why Jupyter server get restarted?


6. Locally verified that whenever ambari-agent service is restarted, Jupyter server will be restarted, as shown in ambari-agent logs:
```
Jul 17 19:02:29 hn0-kcspark  ambari_agent - RecoveryManager.py - [2816] - root - INFO - JUPYTER_MASTER needs recovery, desired = STARTED, and current = INSTALLED.
```

Above Steps details how to traces a request starting from YARN application to Jupyter logs 

