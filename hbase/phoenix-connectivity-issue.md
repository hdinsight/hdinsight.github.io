---
title: Not able to connect with Phoenix | Microsoft Docs
description: Troubleshooting the connectivity issue with Apache Phoenix via JDBC or sqlline.py.
services: hdinsight
documentationcenter: ''
author: nitinver
manager: ashitg

ms.service: hdinsight
ms.custom: hdinsightactive
ms.devlang: na
ms.topic: article
ms.tgt_pltfrm: na
ms.workload: big-data
ms.date: 04/10/2017
ms.author: nitinver
---

# Troubleshooting the connectivity issue with Apache Phoenix via JDBC or sqlline.py

Below are the steps that can be followed to troubleshoot connectivity issue with Apache phoenix. 

1) In order to connect with Apache phoenix, the user needs to provide the IP of active zookeeper node. Ensure that zookeeper service to which sqlline.py is trying to connect is up and running.
2) Perform SSH login to the HDInsight cluster.
3) Try following command:
        
        "/usr/hdp/current/phoenix-client/bin/sqlline.py <IP of machine where Active Zookeeper is running"
        
       Note: The IP of Active Zooker node can be identified from Ambari UI, by following the links to HBase -> "Quick Links" -> "ZK* (Active)" -> "Zookeeper Info". 
       
4) If the sqlline.py connects to Apache Phoenix and does not timeout, run following command to validate the availability and health of Apache Phoenix:
    
        !tables
        !quit
        
   If the above commands works, then there is no issue. The IP provided by user could be incorrect.
   
5) On the other hand, if the command pauses for too long and then throws the error mentions below, continue to follow the troubleshooting guide below:

        Error while connecting to sqlline.py (Hbase - phoenix) Setting property: [isolation, TRANSACTION_READ_COMMITTED] issuing: !connect jdbc:phoenix:10.2.0.7 none none org.apache.phoenix.jdbc.PhoenixDriver Connecting to jdbc:phoenix:10.2.0.7 SLF4J: Class path contains multiple SLF4J bindings. 
        
6) Run following commands from headnode (hn0) to diagnose the condition of phoenix SYSTEM.CATALOG table:

        hbase shell
        
        count 'SYSTEM.CATALOG'
        
      The command should return an error similar to following: 
      
        ERROR: org.apache.hadoop.hbase.NotServingRegionException: Region SYSTEM.CATALOG,,1485464083256.c0568c94033870c517ed36c45da98129. is not online on 10.2.0.5,16020,1489466172189) 
        
7) Restart the HMaster service on all the zookeeper nodes from Ambari UI by following steps below:

    A. Go to "HBase -> Active HBase Master" link in summary section of HBase. 
    B. In Components section, restart the HBase Master service.
    C. Repeat the above steps for remaining "Standby HBase Master" services. 
    
8) It can take up-to 5 minutes for HBase Master service to stabilize and finish the recovery. 

9) After few minutes of wait, repeat the steps 3) and 4) to confirm that system catalog table is up and can be queried. 

10) Once the 'SYSTEM.CATALOG' table is back to normal, the connectivity issue to Apache Phoenix should get resolved automatically.

        