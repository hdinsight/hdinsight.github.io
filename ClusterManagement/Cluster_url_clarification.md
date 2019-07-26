### URL difference
[Offcial doc](https://hadoop.apache.org/docs/r2.7.3/) lists 
all the APIs for each hadoop relevant service. However, because of the Gateway policy, HDInsight sometimes uses different URL to get the info. 
This doc is an URL clarifaction for cases we knew so far. We would keep this file updated once we see more cases.

### MapReduce API
* Apache Hadoop
```
 http://<proxy http address:port>/proxy/{appid}/ws/v1/mapreduce
 http://<proxy http address:port>/proxy/{appid}/ws/v1/mapreduce/info
```
* HDInsight

running job -->
```
 https://<url>/yarnui/proxy/application_<id>_<id>/ws/v1/mapreduce/info
```
finised job --> 
```
 https://<url>/yarnui/jobhistory/job/job_<id>_<id>/ws/v1/mapreduce/info
```
The first URL will be auto re-directed to the second URL if the job is already finished.

