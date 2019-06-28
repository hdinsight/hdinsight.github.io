On secure clusters, by default, all domain users in AAD DS are allowed to SSH into the head and edge nodes. These users are not part of the sudoers group and do not get root access. The SSH user created during cluster creation will have root access. 

To restrict SSH access to specific users or groups, update the /etc/ssh/sshd_config on each of the nodes. Add or edit the following line. You can add any number of values separated by a space. You can either allow specific users or specific groups.

AllowUsers <useralias1> <useralias2>
AllowGroups <groupname1> <groupname2>

Save the file and restart sshd using the following command
sudo systemctl restart sshd
