---
title: ADLS cluster creation service principal format | Microsoft Docs
description: Getting base-64 encoded certificate string from pfx certificate.
services: hdinsight
documentationcenter: ''
author: vahemesw
manager: vinayb

ms.service: hdinsight
ms.custom: hdinsightactive
ms.devlang: na
ms.topic: article
ms.tgt_pltfrm: na
ms.workload: big-data
ms.date: 10/09/2017
ms.author: vahemesw
---

### Converting service principal pfx certificate contents to base-64 encoded string format

#### Error message:

The input is not a valid Base-64 string as it contains a non-base 64 character, more than two padding characters, or a non-white space character among the padding characters

#### Detailed Description:

When using PowerShell or Azure template deployment to create clusters with DataLake as either primary or additional storage, the service principal certificate contents provided to access DataLake storage account is in the base-64 format. Improper conversion of pfx certificate contents to base-64 encoded string can lead to this error.

#### Resolution Steps:

Once you have the service principal certificate in pfx format (see [here](https://github.com/Azure/azure-quickstart-templates/tree/master/201-hdinsight-datalake-store-azure-storage) for sample service principal creation steps), use the following PowerShell command or C# snippet to convert the certificate contents to base-64 format.

Using PowerShell

~~~~
$servicePrincipalCertificateBase64 = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes(path-to-servicePrincipalCertificatePfxFile))
~~~~

Using C# code snippet

~~~
using System;
using System.IO;

namespace ConsoleApplication
{
    class Program
    {
        static void Main(string[] args)
        {
            var certContents = File.ReadAllBytes(@"<path to pfx file>");
            string certificateData = Convert.ToBase64String(certContents);
            System.Diagnostics.Debug.WriteLine(certificateData);
        }
    }
} 
~~~