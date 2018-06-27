## Streaming tab not visible in Spark History Server UI
Issue : Streaming tab is not available in Spark History Server UI for any (success/failed) completed Streaming application.

Cause: Support for Stream UI in Spark History Server is still a open ask within Spark community Reason being streaming events are not being written. JIRA open here: https://issues.apache.org/jira/browse/SPARK-12140.

Note: One of the major concerns for this JIRA still being open is that streaming event logs can be extremely huge and can lead to slowness in UI rendering.
