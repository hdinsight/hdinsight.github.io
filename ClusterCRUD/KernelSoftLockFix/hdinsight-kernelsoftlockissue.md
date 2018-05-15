### One or more nodes in HDInsight cluster becomes unresponsive, heartbeats for that node is lost and unable to ssh to that specific node. 
### On contacting Microsoft support, they restart the affected nodes and recommend to upgrade the linux kernel from 4.13 to 4.15 by following the instructions under Recommended Steps.

### Hint : Run ```uname -r``` to identify the kernel version, while you are ssh'd to the affected node. 

## **Recommended steps**
To resolve kernel soft lock issue, execute the script action on your HDInsight cluster by following these steps. This script upgrades the linux kernel and reboots the machines at different times in the next 24 hours:

1. Navigate to your HDInsights cluster from Azure portal

2. Go to script actions

3. Click Submit New and enter the input as follows (Screenshot media\ExecuteScriptAction.jpg is available for your reference):
	
	Script Type: -Custom
	
	Name: Fix for kernel soft lock issue

	Bash script URI: [https://raw.githubusercontent.com/hdinsight/hdinsight.github.io/master/ClusterCRUD/KernelSoftLockFix/scripts/KernelSoftLockIssue_FixAndReboot.sh](https://raw.githubusercontent.com/hdinsight/hdinsight.github.io/master/ClusterCRUD/KernelSoftLockFix/scripts/KernelSoftLockIssue_FixAndReboot.sh)

	Node types: Head/worker/zookeper
	
	Check "Persist this script action" if you want the execute the script when new nodes are added.
	
	Click Create button
	
4. Wait for the execution to succeed.

