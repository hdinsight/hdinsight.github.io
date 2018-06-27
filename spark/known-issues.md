# List of known Issue / not supported yet.

## Streaming tab not visible in Spark History Server UI
Issue : Streaming tab is not available in Spark History Server UI for any (success/failed) completed Streaming application.

Cause: Support for Stream UI in Spark History Server is still a open ask within Spark community Reason being streaming events are not being written. JIRA open here: https://issues.apache.org/jira/browse/SPARK-12140.

Note: One of the major concerns for this JIRA still being open is that streaming event logs can be extremely huge and can lead to slowness in UI rendering.


## Trying to create a table with buckets using Jupyter, it failed with following error:
```
'\\nOperation not allowed: CREATE TABLE ... CLUSTERED BY(line 2, pos 0)\\n\\n== SQL ==\\n\\nCREATE TABLE CUST_NAME_INT_TEMP\\n^^^\\n(\\n ECMS_ID integer,\\n APP_ID integer,\\n APP_CUST_ID integer,\\n ORIGINATING_SYSTEM_ID integer,\\n ORIGINATING_SYSTEM_DESCRIPTION string,\\n ACTION integer,\\n TITLE string,\\n SUFFIX string,\\n GENDER string,\\n CREATE_DATE date,\\n CUST_TYPE_DESCRIPTION string,\\n CUST_STATUS_DESCRIPTION string,\\n CUST_STATUS_REASON_TYPE_DESCRIPTION string,\\n EFF_DATE date,\\n TERM_DATE date\\n)\\nclustered by (ECMS_ID) into 2 buckets STORED AS ORC TBLPROPERTIES ('transactional'='true') \\n'
```

Cause: Tables with buckets functionality is not Supported.
Tables with buckets: bucket is the hash partitioning within a Hive table partition. Spark SQL doesn’t support buckets yet.
Refer : https://spark.apache.org/docs/2.1.0/sql-programming-guide.html#unsupported-hive-functionality
