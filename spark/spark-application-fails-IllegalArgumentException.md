## Getting following exception when trying to execute a Sparkactivity Pipeline part of Azure Data Factory
Exception in thread "main" java.lang.IllegalArgumentException: Wrong FS: wasbs://additional@kcwasbsrepro.blob.core.windows.net/spark-examples_2.11-2.1.0.jar, expected: wasbs://wasbsrepro-2017-11-07t00-59-42-722z@kcwasbsrepro.blob.core.windows.net 

#### Issue could be reproduced with the application file (jar / py) stored on a non-default container part of the default storage and the storage is enable for secure transfer

	Blob storage : http:///kcwasbsrepro.blob.core.windows.net 
	Default container : wasbsrepro-2017-11-07t00-59-42-722z 
	Addictional Container: http:///kcwasbsrepro.blob.core.windows.net/additional 

#### Cause:This is a known issue with the Spark open source framework tracked here: https://issues.apache.org/jira/browse/SPARK-22587
Spark job will fail if application jar is not located in the Spark cluster’s default/primary storage. 
	
#### Mitigation: Make sure the application jar is stored on the primary storage  	
Incase of Azure Data Factory make sure the ADF linked service is pointed to the HDI default container rather than a secondary container.
	