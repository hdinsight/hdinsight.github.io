### Symptom : One or more nodes in HDInsight cluster becomes unresponsive, heartbeats for that node is lost and unable to ssh to that specific node. 

If you cannot ssh, please contact Microsoft support so that they can restart the affected nodes.

Search in the kernel Syslogs and if you see “watchdog: BUG: soft lockup – CPU” appear then you are hitting a <a href="https://bugzilla.kernel.org/show_bug.cgi?id=199437">bug</a> in Linux Kernel which is causing CPU soft lockups and the rest of this TSG applies to you.

Once the node is up, run the below script action which will apply the kernel patch and will schedule reboots in a staggered manner. 

If you see "watchdog: BUG: soft lockup – CPU" in Syslogs, but never lost ssh, you can still follow the recommended steps.

## **Recommended steps**

To resolve kernel soft lock issue, execute the script action on your HDInsight cluster by following these steps. This script upgrades the linux kernel and reboots the machines at different times in the next 24 hours:

1. Navigate to your HDInsight cluster from Azure portal

2. Go to script actions

3. Click Submit New and enter the input as follows [Screenshot] (media\ExecuteScriptAction.jpg) is available for your reference):
	
	Script Type: -Custom
	
	Name: Fix for kernel soft lock issue

	Bash script URI: [https://raw.githubusercontent.com/hdinsight/hdinsight.github.io/master/ClusterCRUD/KernelSoftLockFix/scripts/KernelSoftLockIssue_FixAndReboot.sh](https://raw.githubusercontent.com/hdinsight/hdinsight.github.io/master/ClusterCRUD/KernelSoftLockFix/scripts/KernelSoftLockIssue_FixAndReboot.sh)

	Node types: Head/worker/zookeper
	
	Check "Persist this script action" if you want the execute the script when new nodes are added.
	
	Click Create button
	
4. Wait for the execution to succeed.

