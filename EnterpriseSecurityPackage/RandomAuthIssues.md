### Debugging seemingly random authentication issues
Customers have run into seemingly random authentication failures, where the user account that they were using to run the jobs is getting "Unauthorized" errors.

### Primary causes
* Authentication errors
  * User account gets locked out and recovers in about 15 minutes or so, by themselves
    * In some cases, there is a pattern (happens every 12 hours). In other cases, it is toally random
  * In some cases, the jobs have to be stopped for the user account to recover
  * SSH access works in all nodes except a few nodes
    * Other users can SSH into the same node, but not this one user
* Authorization errors
  * Some queries or hdfs dfs -ls commands are working and some are not
    * Most common cause is that the user doesn't have permissions to some files or folders and has access to others
  
### Debugging authentication errors
* Common questions we get are
  * What logs will help debug this issue?
  * How can we avoid these issues?
    
### What logs exist to debug authentication errors?
* These authentication errors are best debugged at the client side.
* If Kerberos initialization fails, log the entire error response
  * You can increase kerberos tracing by setting export KRB5_TRACE=/tmp/krb.log
  * If you are using a custom PAM module for authentication, then find out how to enable its log level to debug mode
  * SSHd logs into the auth.log facility
  * If the user is locked out in AAD, it doesn't impact AAD DS and vice versa. Those 2 systems do not sync on this property

### How to know more about who attempted bad logins?
* Follow the steps to [manage AAD DS domain] (https://docs.microsoft.com/en-us/azure/active-directory-domain-services/manage-domain)
  * Each user object has properties like pwdLastSet, badPasswordTime, lastLoginTimestamp etc... that will give you more information
  * If you are able to look at these values within 15 minutes from the time the problem started, you will get a much better picture
    
### How to avoid these errors?
  * It is easier and sometimes faster to review the issues around cluster access instead of going through tons of logs
  * If you shared the username and password with many of your team members, they could try a bad password or run a bad script bringing down all the jobs
  * If you have stored passwords on the nodes, then you can't control password changes
  * If you use custom code to encrypt / decrypt passwords, then anytime decrypt fails or if the password is changed, then you could see such issues
  * Use a dedicated user account for each scenario / tool. 
    * This will help you isolate the issues to a smaller scope and will also increase the security of the system
  * If you are really security conscious, we would recommend rotating the username and/or password periodically
    * Changing passwords alone will not help the lockout issue
  * Do not allow users to login to the servers where critical jobs are running
    * Add an empty edge node where the passwords are not stored and let users run their adhoc scripts from there
    * Do not allow the users to use the same user accounts as jobs
  * Use keytabs and kinit wherever possible, instead of custom ACLing and custom encryption
  
### How to debug using Kerberos client side traces?
* Easiest way is to compare a successful and failed case and see the stage where the problem starts
* Pre-authentication failure will contain specific error codes that should have more meaningful information
  
### How about server side logs?
 * Turning on kerberos tracing and looking for failed events is very expensive
 * Domain Controllers will not log explicitly what you are looking for. You will be trying to eliminate good and bad login attempts from too many logs
 * This cannot be done by customers, requires a support request
