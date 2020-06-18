#!/bin/bash

# ##################################################
# upgrade script/v1
#
# HISTORY:
#
# This short script consist three different parts. The first one does just a system upgrade. It's important
# to know, if the script did not run by root user, it's exit just after the first part for some security
# reason. After this, if there's any unuseful torrent files left in Downloads directory, it will be removed
# them all.
# Finally, if the capacity of home partition exceeds 90%, it will be triggered and notify the user.
# I will modify the script later as allows to send email to user about what happened after running the script.
# Nevertheless, this is the version 1, feel free to reuse it.
#
# DATE: 18.06.2020
#
# Homepage https://github.com/SandorJokai/bash
#
# ##################################################


#Declare Variables
TORRENTS="/home/shanx/Downloads/*.torrent"
CAPACITY=`df /home | cut -d " " -f 6 | sed 's/.$//'`

#First thing is to find out whether is root or not.
#It is important when we run the script manually, but not using by cronjob.
if [ "$EUID" -ne 0 ]
then
	echo "You have no got permission to do that. Please, run this script with sudo or as root!"
	exit 0
else
	apt update && apt upgrade -y
fi


#In this section the script will be deleted all leftover torrent files.
if [[ $TORRENTS ]]
then
	for i in $TORRENTS;do
		rm -f $TORRENTS
	done
	echo "All torrent files has been deleted!"

fi

#Finally, this statement can shows us if the space is getting run out.
if [ $CAPACITY -ge 90 ]
then
	echo "Your home partition's capacity is more than 90%, it's time to save more space!"
fi
