

# Zeppelin Notebook#

## Troubleshoot Zeppelin 101 ##

Its easy to validate the service from Ambari, detailed the steps below to confirm the service status from SSH.

Switch user to zeppelin using command ```su zeppelin``` before you check the status.  
To validate the service state use following command.   
```usr/hdp/current/zeppelin-server/bin/zeppelin-daemon.sh status```  
To confirm the version
```usr/hdp/current/zeppelin-server/bin/zeppelin-daemon.sh --version```  
use command ```ps -aux | grep zeppelin``` to identify PID, etc


## Zeppelin Log & Configuration ##
|Service|Path|
|:--|:--|
|zeppelin-server|/usr/hdp/current/zeppelin-server/|
|Server Logs|/var/log/zeppelin|
|**Configuration**
Interpreter,Shiro,site.xml,log4j|/usr/hdp/current/zeppelin-server/conf or /etc/zeppelin/conf|
|PID directory|/var/run/zeppelin|



## Steps to enable debug logging for Zeppelin ##
Set below configuration in ```Advanced zeppelin-log4j-properties``` under ```Zeppelin Notebook``` from Ambari 
```
log4j.appender.dailyfile.Threshold = DEBUG
log4j.logger.org.apache.zeppelin.realm=DEBUG 
```

*   Restart Zeppelin service from ambari after saving Zeppelin.config file with the above changes.
*   Zeppelin-Zeppelin-<Headnode>.log under ```/var/log/zeppelin``` will contain the debug entries.  

Reference : https://community.hortonworks.com/articles/70658/how-to-diagnose-zeppelin.html
