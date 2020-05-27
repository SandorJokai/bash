#!/bin/bash

# ##################################################
# My simple backup script
#
# HISTORY:
#
# This script can make a compressed backup about a specific directory. I combined with in-built cron, so
# after the first manually running whilst it checks the exists of directories and the script is available in
# /etc/cron.weekly directory as well, it will be running in every day (in my case) and make an INCREMENTAL 
# backing up. It also creates a log file in /var/log directory.
#
# DATE: 27.05.2020
#
# Homepage https://github.com/SandorJokai/bash
#
# ##################################################


# variables
LOG_LOC="/var/log/mybackup.log"
backup_dir="/home/shanx/DevOps/ansible/apache"
compressed_dir="/path/to/backed_up"
script_loc="/home/shanx/Dokumentumok/gyak/bash_examples/2020/backup.sh"
path="/home/shanx/DevOps/ansible/apache/dirs.txt"

# Create a file with just "1" value for working the backup function properly.
echo "1" > $path

function compressed_dir {
	if [ ! -d $compressed_dir ];then
		echo "Please create the $compressed_dir path for backup archives! "
		exit 1
	fi
}

function check_cron {
	if [ ! -s "/etc/cron.hourly/backup" ]
	then
		sudo cp $script_loc /etc/cron.weekly/backup
		echo "The backup script has been sent to /etc/cron.weekly!"
		exit 1
	fi
}

function perform_backup {
	echo "Back up performing is in process..." > $LOG_LOC
	while read dirs
	do
		filename=$compressed_dir.tar.gz
		tar -czf $filename $backup_dir 2>> $LOG_LOC
		mv $filename $compressed_dir
		echo "Backing up is completed." >> $LOG_LOC

	done < $path
	echo "Backup was completed at: " >> $LOG_LOC
	date >> $LOG_LOC
}

compressed_dir
check_cron
perform_backup
