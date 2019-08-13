### Summary
HDInsight ESP clusters use Ranger for authorization. Ambari and Ranger both sync users and groups independently and work a little differently. This page is meant to address the LDAP sync in Ranger and Ambari and provide best practices.

### Best practices
* Always deploy clusters with groups
* Instead of changing group filters in Ambari and Ranger, try to manage all these in AAD and use the nested groups to bring in the required users
* Once a user is synced, it is not removed even if the user is not part of the groups
* If you need to change the LDAP filters directly, use the UI first as it contains some validations

### Why do we sync users into Ambari and Ranger separately?
Ambari and Ranger are serving 2 different purposes, do not share the user database.
* If the user needs to use the Ambari UI, then the user needs to be synced to Ambari so that you can create views etc... If the user is not synced to Ambari, Ambari UI / API will reject it but other parts of the system will work (these are guarded by Ranger or Resource Manager and not Ambari).
* If you want to include the user into a Ranger policy, then sync the user to Ranger.

When a secure cluster is deployed, we sync the group members transitively (all the subgroups and their members) to both Ambari and Ranger. During the lifetime of the cluster, the users may want to change the details of the sync or debugging some sync related issues.

### Ambari user sync and configuration
From the head nodes, a cron job (/opt/startup_scripts/start_ambari_ldap_sync.py) is run every hour to schedule the user sync. The cron job calls the ambari rest apis to perform the sync. The script submits a list of users and groups to sync (as the users may not belong to the specified groups, both are specified individually). Ambari syncs the sAMAccountName as the username and all the group members, transitively.

The logs should be in /var/log/ambari-server/ambari-server.log. You can increase the log levels by following https://docs.hortonworks.com/HDPDocuments/Ambari-2.7.3.0/administering-ambari/content/amb_configure_ambari_logging_level.html

In datalake clusters, we use the post user creation hook to create the home folders for the synced users and set them as the owners of the home folders.

### Ranger User sync and configuration
Ranger has an inbuilt sync engine that runs every hour to sync the users. It doesn't share the user database with Ambari. 

HDInsight configures the search filter to sync the admin user, the watchdog user and the members of the group specified during the cluster creation. The group members will be synced transitively.
* Disable incremental sync
* Enable User group sync map
* Specify the search filter to include the transitive group members
* Sync sAMAccountName for users and name attribute for groups

#### Why doesn't HDI sync Ranger groups directly
Ranger does support a sync filter to sync users who are either from a list of users or part ofthe specified groups. Instead, Ranger will intersect the user names and memberships. So, we specifiy Ranger to sync the users from a filter with all their group memberships.

### Ranger  User sync logs
Ranger user sync can happen out of either of the headnodes. The logs are in /var/log/ranger/usersync/usersync.log. To increase the verbosity of the logs, do the following

* Login to Ambari using an ambari admin
* Go to the Ranger configuration section
* Go to the Advanced usersync-log4j section
* Change the log4j.rootLogger to DEBUG level (After change it should look like log4j.rootLogger = DEBUG,logFile,FilterLog)
* Save the configuration and restart ranger
