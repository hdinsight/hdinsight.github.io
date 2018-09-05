
# Spark Logs and Configurations #
* Lookup for Spark2 directory using command `ls /usr/hdp/current | grep spark2` 

|Path|Purpose|
|--|--|
|/usr/hdp/current/spark2-client | Submitting Spark 2 jobs|
|/usr/hdp/current/spark2-history | Launching Spark 2 master processes, such as the Spark 2 History Server|
|/usr/hdp/current/spark2-thriftserver| Spark 2 Thrift Server|

**Services available with Spark**

|Service|Configurations|HA|
|--|--|--|
|Spark2 Clients|/usr/hdp/current/spark-client/conf/spark-default.conf| Yes (Installed on Worker and Headnodes)
|Spark Thrift Server|/usr/hdp/current/spark-client/conf/spark-thrift-sparkconf.conf|Yes, Headnodes|
|Spark2History Server||Yes|
|livy for Spark2 server||No|

* `Spark thrift Server` is a service that allows JDBC and ODBC clients to run Spark SQL queries. The Spark Thrift server is a variant of HiveServer2 and is always configured to start in Client-mode