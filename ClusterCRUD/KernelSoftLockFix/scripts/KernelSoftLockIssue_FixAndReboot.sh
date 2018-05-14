#!/bin/bash

#This script is to fix the kernel soft lock issue by upgrading linux. Then it performs an on-demand reboot of nodes in a cluster with difference in their scheduled reboot times
#The filename must not have any extension.

#Version 2.1
#Reads config file at /usr/hdinsight/.managed_patching_reboot_config

# Upgrade Linux

grep -q -F "deb http://archive.ubuntu.com/ubuntu/ xenial-proposed restricted main multiverse universe" /etc/apt/sources.list
if [$? -ne 0]; 
then
	sudo echo "deb http://archive.ubuntu.com/ubuntu/ xenial-proposed restricted main multiverse universe" >> /etc/apt/sources.list
	logger -p user.info "Updated sources list"
else
	sudo echo "Kernel soft lock patch already exists"
	logger -p user.info "Kernel soft lock patch already exists. Exit."
	exit 0
fi
sudo apt-get update
logger -p user.info "Completed apt-get update"
sudo apt-get install linux-azure-edge -y
logger -p user.info "Installed linus-azure-edge"

# Install package 'bc' for performing floating point arithmetic
if [ $(dpkg-query -W -f='${Status}' bc 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
  echo "Installing package bc"
  logger -p user.info "Installing package bc"
  sudo apt-get install bc;
fi

# Set number of reboot slots to 48 by default. Read the actual value from configuration file later.
# Currently the cron jobs runs every 30 minutes. If the number of slots is increased so that reboots
# should occur, say 20 minutes, then the cron job should be modified to run every 20 minutes.
# We assume that total reboot cycle is not > 24 hours.
count_reboot_slots=48
total_reboot_cycle_duration_hours=24

hostname=$(/bin/hostname -f)
host_instance=$(sed 's/[^0-9]*\([0-9]*\).*/\1/' <<< $hostname)

echo "Current hostname is $hostname."
echo "Current host instance is $host_instance"

# Utility method to convert time slot to "HH:MM"
convert_slot_to_time() {
  slots_per_hour=$(bc <<< "scale=5;$count_reboot_slots/$total_reboot_cycle_duration_hours")
  slot_duration=$(bc <<< "scale=0;60/$slots_per_hour")
  hour=$(( ((($1*$slot_duration) / 60) % $total_reboot_cycle_duration_hours) % 24 ))
  minute=$(( ($1*slot_duration) % 60 ))
totalminutes=$(((hour*60)+minute))
echo $totalminutes
}

# Check if fault/update domain aware managed patching is enabled.
fd_ud_aware_managed_patching_enabled_flag_path="/usr/hdinsight/.enable_fd_ud_aware_managed_patching_reboot"
if [ -e "$fd_ud_aware_managed_patching_enabled_flag_path" ]
then
  # FD/UD aware patching is only enabled for Kafka clusters.
  # Check if all Kafka brokers are healthy via Kafka Probe output before proceeding.
  
  kafka_brokers_heathy="/usr/hdinsight/.kafka_brokers_healthy"
  if [ -e "$kafka_brokers_heathy" ]
  then
    echo "Kafka brokers are healthy. Checking if reboot slot has arrived."
    logger -p user.info "Kafka brokers are healthy. Checking if reboot slot has arrived."
  else
    echo "Kafka brokers are not healthy. Aborting reboot."
    logger -p user.info "Kafka brokers are not healthy. Aborting reboot."
   # exit 0
  fi

  # We wish to reboot VMs 30 minutes apart within the same host group across the span of 24 hours.
  # This corresponds to 48 individual reboot slots that we need to map the hosts to. The number of slots (48) is configurable
  # via the PatchingManager (configure_managed_patching_reboot.py).
  # PatchingManager assigns a slot between [0,48) for each node within a host group.
  echo "FD/UD aware managed patching reboot is enabled."
  short_hostname="$(cut -d'.' -f1 <<<"$hostname")"
  assigned_reboot_slots_filepath="/usr/hdinsight/.reboot_slots"
  reboot_time_slot=$(sed -n "/^${short_hostname},\([0-9]*\)$/s//\1/p" $assigned_reboot_slots_filepath)
  reboot_in_minutes=$(convert_slot_to_time $reboot_time_slot)

  echo "Reboot time slot: $reboot_time_slot"
  logger -p user.info "Reboot time slot: $reboot_time_slot"
  logger -p user.info "Reboot time: $reboot_in_minutes"
else
  echo "Update domain aware managed patching reboot is disabled."
  logger -p user.info "Update domain aware managed patching reboot is disabled."
  
  # Assign a slot to the VM based on it's host instance.
  host_instance_mod_48=$(( host_instance % 48 ))
  reboot_in_minutes=$(convert_slot_to_time $host_instance_mod_48)
fi

reboot_in_minutes_with_waittime=$(( reboot_in_minutes + 15 ))
echo "reboot_in_minutes $reboot_in_minutes"
echo "reboot_in_minutes_with_waittime $reboot_in_minutes_with_waittime"
logger -p user.info "Scheduling reboot in $reboot_in_minutes_with_waittime minutes."
#Broadcast message to all logged on users.
wall <<< "This virtual machine will be rebooted in $reboot_in_minutes_with_waittime minutes to apply security patches. Run 'sudo shutdown -r' to reboot at any time."

#Give a final 15 minute warning before shutdown
logger -p user.info "Rebooting in $reboot_in_minutes_with_waittime minutes."
sudo /sbin/shutdown -r +$reboot_in_minutes_with_waittime


