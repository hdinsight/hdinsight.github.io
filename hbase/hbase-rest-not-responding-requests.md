---
title: HDinsight HBase REST not Responding to Requests | Microsoft Docs
description: Mitigation of HBase REST not responding to requests.
services: hdinsight
documentationcenter: ''
author: dule
manager: mitrabmo

ms.service: hdinsight
ms.custom: hdinsightactive
ms.devlang: na
ms.topic: article
ms.tgt_pltfrm: na
ms.workload: big-data
ms.date: 08/20/2018
ms.author: dule
---

# How to Fix the Issue with HDinsight HBase REST not Responding to Requests

The possible cause here could be HBase REST service was leaking sockets, which is especially common when the service has been running for a long time (e.g. months).

The observed errors on client SDK is

       System.Net.WebException : Unable to connect to the remote server ---> System.Net.Sockets.SocketException : A connection attempt failed because the connected party did not properly respond after a period of time, or established connection failed because connected host has failed to respond 10.0.0.19:8090

To fix this issue, restart HBase REST using the below command after SSHing to the host. You can also use script actions to restart this service on all workernodes.

       sudo service hdinsight-hbrest restart

Note that this command will stop HBase Region Server on the same host. You can either manually start HBase Region Server through Ambari, or let Ambari auto-restart functionality to recover HBase Region Server automatically.