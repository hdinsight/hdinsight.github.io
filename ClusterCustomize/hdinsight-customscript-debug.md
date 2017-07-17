# I want to debug custom script failure

## **Issue**
 Customer specifies a script action when creating an HDInsight cluster, but the deployment failed due to "CustomizationFailedErrorCode".
 
## **Debugging Steps**
 1. Create a cluster without script actions. This should be successful.
 2. In portal, submit an script action on the running cluster. The script action failed.
 3. Login to user's cluster Ambari page, click on the "x ops" button right next to the cluster name on the top bar. You should see an operation called "run_customscriptaction" that failed. Click on it.
 4. Pick on a host name from the list where the script invokation failed:
 5. You should be able to see the stderr and stdout of the custom action. This is an example of the failure in stderr:
     sudo: /usr/bin/livy2/: command not found
    /tmp/tmpfu6dEe: line 31: ./bin/livy-server: No such file or directory
    Traceback (most recent call last):
      File "/var/lib/ambari-agent/cache/custom_actions/scripts/run_customscriptaction.py", line 194, in <module>
        ExecuteScriptAction().execute()
      File "/usr/lib/python2.6/site-packages/resource_management/libraries/script/script.py", line 314, in execute
        method(env)
      File "/var/lib/ambari-agent/cache/custom_actions/scripts/run_customscriptaction.py", line 179, in actionexecute
        ExecuteScriptAction.execute_bash_script(bash_script, scriptpath, scriptparams)
      File "/var/lib/ambari-agent/cache/custom_actions/scripts/run_customscriptaction.py", line 149, in execute_bash_script
        raise Exception("Execution of custom script failed with exit code",exitcode)
    Exception: ('Execution of custom script failed with exit code', 127)
 
## **Recommended documents**
[Custom Script actions](https://docs.microsoft.com/azure/hdinsight/hdinsight-hadoop-customize-cluster-linux)<br>
