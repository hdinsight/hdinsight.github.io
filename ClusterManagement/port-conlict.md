# Can't start service due to port conflict error.

We've seen several failures on booting up services due to the port conflict exception. There's also a change made to add reserved port 
so as to reduce the chance of encountering this issue. However, it may still happen for existing clusters.

# Mitigation
1. 
use below commands to get/kill all the running processes which are affected by the port issue. Restart after clean up.
```
netstat -lntp | grep <port>
ps -ef | grep <service>
kill -9 <service>
```


2.
or you can reboot the node, which will also cleanup the ports being used for each service.
