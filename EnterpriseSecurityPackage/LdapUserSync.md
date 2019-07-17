### Summary
HDInsight ESP clusters use Ranger for authorization. Ambari and Ranger both sync users and groups independently and work a little differently. This page is meant to address the LDAP sync in Ranger and Ambari.

### Supported ranger User sync configuration
Enable user sync (do not enable group sync) - HDInsight configures the search filter to sync the admin user, the watchdog user and the members of the group specified during the cluster creation. The group members will be synced transitively.
Disable incremental sync
Enable User group sync map
Ranger user sync runs every 1 hour

### Ambari user sync configuration
From the headnodehost, a cron job is run every hour to schedule a user sync. The logs should be in /var/log/ambari-server/ambari-server.log. You can increase the log levels by following https://docs.hortonworks.com/HDPDocuments/Ambari-2.7.3.0/administering-ambari/content/amb_configure_ambari_logging_level.html

### Ranger  User sync logs
Ranger user sync can happen out of either of the headnodes. The logs are in /var/log/ranger/usersync/usersync.log. To increase the verbosity of the logs, do the following

* Login to Ambari using an ambari admin
* Go to the Ranger configuration section
* Go to the Advanced usersync-log4j section
* Change the log4j.rootLogger to DEBUG level (After change it should look like log4j.rootLogger = DEBUG,logFile,FilterLog)
* Save the configuration and restart ranger
