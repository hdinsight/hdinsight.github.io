# One or more nodes in HDInsights cluster becomes unresponsive, no heartbeat from the node and cannot ssh. On contacting Microsoft support, they restart the affected nodes and they recommend to patch the linux kernel by following these instructions.

## **Recommended steps**
To resolve kernel soft lock issue, execute the script action on your HDInsight cluster by following these steps. This script upgrades the linux kernel and reboots the machines at different times in the next 24 hours:

1. Navigate to your HDInsights cluster from Azure portal

2. Go to script actions

3. Click Submit New and enter the input as follows (Screenshot media\ExecuteScriptAction.jpg is available for your reference):
	
	Script Type: -Custom
	
	Name: Fix for kernel soft lock issue
	
	Bash script URI: https://raw.githubusercontent.com/hdinsight/hdinsight.github.io/master/ClusterCRUD/KernelSoftLockFix/scripts/KernelSoftLockIssue_FixAndReboot.sh
	
	Node types: Head/worker/zookeper
	
	Check "Persist this script action" if you want the execute the script when new nodes are added.
	
	Click Create button
	
4. Wait for the execution to succeed.

