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

The logs should be in /var/log/ambari-server/ambari-server.log. You can increase the [log levels]( https://docs.hortonworks.com/HDPDocuments/Ambari-2.7.3.0/administering-ambari/content/amb_configure_ambari_logging_level.html)

In datalake clusters, we use the post user creation hook to create the home folders for the synced users and set them as the owners of the home folders. If the user is not synced to Ambari correctly, then the user could face failures in accessing staging and other temporary folders.

#### How to update the groups to be synced to Ambari?
You cannot update the existing script to add new groups. If you cannot manage groups memberships in AAD, you have 2 choices. 

1. One time only sync as explained [here](https://docs.hortonworks.com/HDPDocuments/HDP3/HDP-3.1.0/ambari-authentication-ldap-ad/content/authe_ldapad_synchronizing_ldap_users_and_groups.html)
  * Whenever the group membership changes, you will have to do this sync again.
2. Write a cron job, call the [Ambari API periodically](https://community.hortonworks.com/questions/2909/how-do-i-automate-the-ambari-ldap-sync.html) with the new groups.

### Ranger User sync and configuration
Ranger has an inbuilt sync engine that runs every hour to sync the users. It doesn't share the user database with Ambari. 

HDInsight configures the search filter to sync the admin user, the watchdog user and the members of the group specified during the cluster creation. The group members will be synced transitively.
* Disable incremental sync
* Enable User group sync map
* Specify the search filter to include the transitive group members
* Sync sAMAccountName for users and name attribute for groups

#### Why doesn't HDI use Ranger group sync or incremental sync
Ranger supports a group sync option, but it works as an intersection with user filter. Not an union between group memberships and user filter. We do need to sync some users that are not part of the groups and we cannot use the group sync option. A typical use case for group sync filter in ranger is - group filter: (dn=clusteradmingroup), user filter: (city=seattle).

Incremental sync works only for the users who are already synced (the first time). It will not sync any new users added to the groups after the initial sync. So, we cannot use this either.

#### How do I update the ranger sync filter?
The LDAP filter can be found in the Ambari UI, under the Ranger user-sync configuration section. The existing filter will be in the form (|(userPrincipalName=bob@contoso.com)(userPrincipalName=hdiwatchdog-core01@CONTOSO.ONMICROSOFT.COM)(memberOf:1.2.840.113556.1.4.1941:=CN=hadoopgroup,OU=AADDC Users,DC=contoso,DC=onmicrosoft,DC=com)). Ensure that you add predicate at the end and test the filter by using net ads search command or ldp.exe or something.

### Ranger  User sync logs
Ranger user sync can happen out of either of the headnodes. The logs are in /var/log/ranger/usersync/usersync.log. To increase the verbosity of the logs, do the following

* Login to Ambari using an ambari admin
* Go to the Ranger configuration section
* Go to the Advanced usersync-log4j section
* Change the log4j.rootLogger to DEBUG level (After change it should look like log4j.rootLogger = DEBUG,logFile,FilterLog)
* Save the configuration and restart ranger
