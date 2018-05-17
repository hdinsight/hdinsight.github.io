#!/bin/bash

#This script is to fix the kernel soft lock issue by upgrading linux. Then it performs reboot of nodes in a cluster at the same time. Do not use this on non-test clusters and use with caution.
#The filename must not have any extension.

#Version 2.1
#Reads config file at /usr/hdinsight/.managed_patching_reboot_config

# Upgrade Linux

grep -q -F "deb http://archive.ubuntu.com/ubuntu/ xenial-proposed restricted main multiverse universe" /etc/apt/sources.list
if [$? -ne 0]; 
then
	sudo echo "deb http://archive.ubuntu.com/ubuntu/ xenial-proposed restricted main multiverse universe" >> /etc/apt/sources.list
	logger -p user.info "Updated sources list"
fi
sudo apt-get update
logger -p user.info "Completed apt-get update"
sudo apt-get install linux-azure-edge -y
logger -p user.info "Installed linus-azure-edge"

reboot_in_minutes_with_waittime=15
echo "reboot_in_minutes_with_waittime $reboot_in_minutes_with_waittime"
logger -p user.info "RebootAllNodesAtOnce: Scheduling reboot in $reboot_in_minutes_with_waittime minutes."
#Broadcast message to all logged on users.
wall <<< "This virtual machine will be rebooted in $reboot_in_minutes_with_waittime minutes to apply security patches. Run 'sudo shutdown -r' to reboot at any time."

#Give a final 15 minute warning before shutdown
logger -p user.info "Rebooting in $reboot_in_minutes_with_waittime minutes."
sudo /sbin/shutdown -r +$reboot_in_minutes_with_waittime


