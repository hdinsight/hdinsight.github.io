### Cluster node out of disk space
 
### Issue:
Sometimes HDI cluster node can run out of disk space. This sometimes cause job to fail with explicit error message like:
~~~~
/usr/hdp/2.6.3.2-14/hadoop/libexec/hadoop-config.sh: fork: No space left on device.
~~~~
Or, you may find Ambari alerts of type Yarn Nodemanager Alerts like this:
~~~~
local-dirs usable space is below configured utilization percentage
~~~~


### Investigation Steps:
1. Find out which node is running out of disk space. Is it headnode or workernode? Ambari UI can be used to understand this.

2. Find out which folder in the troubling node contributes to most of the disk space. SSH to the node first, then run "df" to list disk usage for all mounts. Usually it is "/mnt" which is an temp disk used by OSS. You can enter into a folder, then type "sudo du -hs" to show summarized file sizes under a folder. 


### Root Causes and workarounds:
Known root causes for disk space full:
#### Yarn application cache take most disk space
You will find that a folder like this takes most of disk space
~~~~
/mnt/resource/hadoop/yarn/local/usercache/livy/appcache/application_1537280705629_0007
~~~~
This means the application is still running. Now you need to find out why the application use that much disk space. What type of application is it? In one instance, we see that one Spark application took 160GB out of 200GB of local SSD (/mnt). This could be due to RDD persistence or intermediate shuffle files. User need to optimize their Spark applications.

To mitigate the problem, you can simply kill the application which will release disk space used by that application.
