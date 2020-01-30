---
title: Azure HDInsight Solutions | Disk Encryption | The HDInsight cluster is unable to access the key for BYOK encryption at rest.
description: How to fix disk encryption alert - The HDInsight cluster is unable to access the key for BYOK encryption at rest.
services: hdinsight
author: karunasagark
ms.author: karkrish
ms.service: hdinsight
ms.custom: troubleshooting
ms.topic: conceptual
ms.date: <01/03/2019>
---

# Azure HDInsight Solutions | Disk Encryption | The HDInsight cluster is unable to access the key for BYOK encryption at rest.

## Scenario: HDInsight clusters configured with disk encryption can lose access to the Key Vault holding the disk encryption key. This leads to alerts in Resource Health Center of Azure portal.

## Issue

The RHC alert - The HDInsight cluster is unable to access the key for BYOK encryption at rest, is shown for BYOK (Bring Your Own Key) clusters where the cluster nodes have lost access to customers Key Vault (KV). Similar alerts can also be seen on Ambari UI.

## Cause

The alert (The HDInsight cluster is unable to access the key for BYOK encryption at rest) ensures that KV is accessible from the cluster nodes, thereby ensuring the network connection, KV health and access policy for the user assigned Managed Identity. This alert is only a warning of impending broker shutdown on subsequent node reboots, the cluster continues to function until nodes reboot.

Navigate to Ambari UI to find more information about the alert from "Disk Encryption Key Vault Status". This would have details about the reason for verification failure.

## Solution

1. KV/AAD outage
    - Look at KV DR - https://docs.microsoft.com/en-us/azure/key-vault/key-vault-disaster-recovery-guidance and Azure status page for more details https://azure.microsoft.com/en-us/status/

2. KV accidental deletion
    - Customer should configure KV with Resource Lock set https://docs.microsoft.com/en-us/azure/azure-resource-manager/resource-group-lock-resources 
    - Additionally customers should back up their keys to their HSM.
    - To mitigate, reach out to KV team to recover from accidental deletions.

3. KV access policy changed
    - Customer should regularly audit and test access policies.
    - To mitigate, restore the access policies for the user assigned Managed Identity that is assigned to HDI cluster for accessing the KV.

4. Key permitted operations
    - For each key in KV, customers can choose the set of permitted operations. Ensure that we have wrap and unwrap operations enabled for the BYOK key

5. Key deletion
    - Cluster should be deleted before key deletion, if key deletion is intentional.
    - To mitigate, customer can restore deleted key on KV and we should be able to auto recover, if key deletion is accidental. See https://docs.microsoft.com/en-us/rest/api/keyvault/recoverdeletedkey

6. Expired key
    - Customers should back up their keys to their HSM.
    - To mitigate,
        * customer can use a key without any expiry set.
        * If expiry needs to be set, customer should rotate the keys before the expiration date.
        * In case, the expiry has passed and key is not rotated, customer needs to restore key from backup HSM or contact KV team to clear the expiry date.

7. KV firewall blocking access
    - To mitigate, customer needs to fix the KV firewall settings to allow BYOK cluster nodes to access the KV.

8. NSG rules on VNet blocking access
    - To mitigate, customer needs to check the NSG rules associated with the VNet attached to the cluster.
