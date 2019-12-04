### Description
On secure clusters, by default, all domain users in AAD DS are allowed to SSH into the head and edge nodes. These users are not part of the sudoers group and do not get root access. The SSH user created during cluster creation will have root access. 

### Restrict users or groups
To restrict SSH access to specific users or groups, update the /etc/ssh/sshd_config on each of the nodes. Add or edit the following line. You can add any number of values separated by a space. You can either allow specific users or specific groups.

AllowUsers useralias1 useralias2

AllowGroups groupname1 groupname2

NOTE: If you restrict users to certain groups, then the local accounts cannot SSH into that node.

Save the file and restart sshd using the following command
sudo systemctl restart sshd

### SSH Authentication log
SSH authentication log is written into /var/log/auth.log. If you see any login failures throug SSH for local or domain accounts, you will need to go through the log to debug the errors yourself. Often the issue might be related to specific user accounts and it is usually a good practise to try other user accounts or SSH using the default SSH user (local account) and then attemptint a kinit. 

### Debug log for SSH
To enable verbose logging, you will need to restart sshd with the -d option. 
Like /usr/sbin/sshd -d
You can also run sshd at a custom port (like 2222) so that you don't have to stop the main SSH daemon.
You can also use -v option with the SSH client to get more logs (client side view of the failures).
