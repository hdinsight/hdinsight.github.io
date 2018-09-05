
## Understanding causes for Yarn node managers showing **unhealthy state** as disks are full ##

### Recommendation ####

1. Local directories could fill up if the following settings are not set properly:
	- Ensure that `yarn.log-aggregation-enabled` is set to `true`. 
		If disabled, NMs will keep the logs locally and not aggregate them in remote store on application completion/termination.
	- Check if `yarn.nodemanager.localizer.cache.cleanup.interval-ms` (default 10 mins) and `yarn.nodemanager.localizer.cache.target-size-mb` (default 10240 MB) are set to reasonable values.
		Cache also uses disk space, so
2. Ensure that the cluster size is appropriate for the workload. 
	-	If this is not the scale, scale up the cluster and retry.
3. /mnt/resource might also get filled with orphaned files (as in the case of RM restart). 
	-	Manually cleaning up `/mnt/resource/hadoop/yarn/log` and `/mnt/resource/hadoop/yarn/local` would help in this scenario.

Execute following Command to Identify which Folder has used up Disk Space 
`du -h --max-depth=1 /`	

What should be the optimal space allocated for the local directory size.
This depends on utilization. [Recommended size for yarn.nodemanager.resource.local-dirs](https://community.hortonworks.com/questions/2230/recommended-size-for-yarnnodemanagerresourcelocal.html) suggests 25%. If the disk space is being used to capacity, please consider scaling up the cluster for more capacity.

REFER : [Resource Localization in YARN: Deep Dive](https://hortonworks.com/blog/resource-localization-in-yarn-deep-dive/)
