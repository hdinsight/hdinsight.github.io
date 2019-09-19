---
title: General advisory on configuring AAD DS for HDInsight secure clusters | Microsoft Docs
description: HDInsight secure clusters require AAD DS for kerberization. This document explains best practices.
keywords: HDInsight ESP AAD DS Kerberos
services: Azure HDInsight
documentationcenter: na
author: vijaysr
manager: ''
editor: ''
ms.topic: article
ms.date: 08/29/2019
ms.author: vijaysr
---

### Why do we need AAD DS?
* Secure clusters require joining to a domain
* HDI cannot depend on on-premise domain controllers or custom domain controllers, as it introduces too many fault points, credential sharing, DNS permissions etc...
* [AAD DS FAQs](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/faqs) has a good list of questions you may have

### AAD DS instance
* Create the instance with the .onmicrosoft.com domain. This way, there won't be multiple DNS servers serving the domain
  * Create a self-signed certificate for the LDAPS and upload it to AAD DS
* Use a peered vnet for deploying clusters (when you have a number of teams deploying HDI ESP clusters, this will be helpful)
  * This ensures that you do not need to open up ports (NSGs) on the VNET with domain controller
* Configure the DNS for the VNETs properly (the AAD DS domain name should resolve without any hosts file entries)
* If you are restricing outbound traffic, make sure that you have read through the [firewall support in HDI](https://docs.microsoft.com/en-us/azure/hdinsight/hdinsight-restrict-outbound-traffic)

### AAD policies
* Disable conditional access policy using the IP address based policy
  * This requires service endpoints to be enabled on the VNETs where the clusters are deployed
  * If you use an external service for MFA (something other than AAD), the IP address based policy won't work
* AllowCloudPasswordValidation policy is required for federated isers
  * Since HDI uses the username / password directly to get tokens from AAD, this policy has to be enabled for all federated users
* Enable service endpoints for AD if you require conditional access bypass using Trusted IPs

### What properties are synced from AAD to AAD DS
* There are 2 syncs involved in sync
 * Azure AD connect syncs from on-premise to AAD
 * AAD DS syncs from AAD
 * During each stage of sync, unique properties may get into conflict and renamed
* Azure AD has some good documentation explaining the first part of the sync
 * [UPN Calculation](https://docs.microsoft.com/en-us/azure/active-directory/hybrid/plan-connect-userprincipalname) is described here
* Azure AD Directory services sync has a documentation explaining the second half of the sync
 * [AAD DS Sync](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/synchronization)
 * Pay attention to the property mapping from AAD to AAD DS
* AAD DS syncs objects from AAD periodically. The AAD DS blade on the Azure portal displays the sync status

### Understand how password hash sync works
* Passwords are synced differently from other object types
  * Only non reversible password hashes are synced in AAD and AAD DS
* On-premise to AAD has to be enabled through AD Connect
* AAD to AAD DS sync is automatic (latencies are under 20 minutes)
* Password hashes are synced only when there is a change password
  * When you enable password hash sync, all existing passwords do not get synced automatically as they are stored irreversibly
  * When you change the password, password hashes get synced

### The domain name in my UPN is different from the AAD DS Realm. Will it work?
* Yes, HDI handles this case
  * AAD DS (domain controllers) support a single REALM
  * AAD supports multiple verified domains
  * So, this is a common use case
* Let us say your AAD DS realm is CONTOSO.ONMICROSOFT.com
* Let us say the userPrincipalName in AAD is bob@contoso.com
* Let us say the sAMAccountName in AAD DS for this user is 'bob'
* Kerberos tickets will be issued for bob@CONTOSO.ONMICROSOFT.com
* AAD Oauth tokens will have UPN as bob@contoso.com

### How can we look at the objects in the AAD DS?
* You can domain join a VM in the cloud and install the required AD tools. [steps](https://docs.microsoft.com/en-us/azure/active-directory-domain-services/tutorial-create-management-vm)

### Where are the computer objects located in AAD DS?
* Each cluster is associated with a single OU
* We provision an internal user in this OU for this cluster
* We domain join all the nodes (head nodes, worker nodes, egde nodes, zookeeper nodes) into the same OU.

