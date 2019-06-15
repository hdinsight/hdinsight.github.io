## Storm Topology Not Processing Messages now. Was working before.

### Issue

The storm topology is not processing any data from Kafka. It was working before.
OR Topologies going stale after few hours of processing.

### Description

A storm topology is comprised of multiple bolts and spouts which form a storm processing pipeline. Bottleneck in any one of them can cause issues in the whole pipeline not being able to process messages.

From the incidents that we have seen with Storm topologies, the issue usually hasn't been with the Apache Storm project itself but the resolution has required tuning on the part of the customers to get the best out of their storm cluster.

Here is a very comprehensive article on Storm Tuning:
https://community.hortonworks.com/articles/62852/feed-the-hungry-squirrel-series-storm-topology-tun.html

### What to check:
1. *Storm UI* and navaigate to the topology that is not processing messages under Topology Summary
https://<clustername>.azurehdinsight.net/stormui

2. Topology Stats 10m 0s window - This would give you the number of messages that are being processed in the last 10 minutes.
3. Topology Summary (Uptime)  - The column uptime gives you how long the topology has been running... If its a few minutes it means the customer redeployed the topology and it will take sometime to catch up. So you should wait for an hour or so before you make any judgement about state of the cluster and what is happening.

4. Bolts (All time) *Capacity* - In Storm UI for topology that is affected check at column *Capacity* for bolts. Any value greater than or close to 1 is an issue. A capacity of 1 means that we are executing at the limit for that particular bolt.
There are multiple bolts and spouts which form a storm processing pipeline. Bottleneck in any one of them can cause issues in the whole pipeline not being able to process messages.

  If the Capacity is higher than 1
    - Ask the customer to look at code optimizations to reduce capacity
    - Suggest increasing parallism and having more executors for the problematic bolt.

6. Kafka Spouts Lag
    - Check the column *Lag* from the Kafka Spout. A value of 0 is what we desire over here
    - Right after redeploy of topology there might be a small amount of time when the lag is not zero when Storm is processing messages from Kafka from the last time it was stopped. Its expected to take sometime to catch up.
 
### How to get DEBUG logs:

  Here are the steps to turn DEBUG logging ON and OFF.
  
  Please replace [VERSION]  [topology name] [logger name] [LEVEL] and [TIMEOUT] with real values corresponding to customers cluster.
  
  
  cd /usr/hdp/[VERSION]/storm
  
  ./bin/storm set_log_level [topology name]-l [logger name]=[LEVEL]:[TIMEOUT]  
  
  *Example:*
  
  cd /usr/hdp/2.6.2.2-5/storm
  
  ./bin/storm set_log_level cy17-binary-decoder -l ROOT=DEBUG:30
  
  ./bin/storm set_log_level cy17-binary-decoder -l ROOT=INFO:30
  
### Immeditate Mitigation
  
A redeploy of topology usually mitigates the problems.

BUT you should strongly consider tuning the topology so that these issues do not occur
  
  
  
  
