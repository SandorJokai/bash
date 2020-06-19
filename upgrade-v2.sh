#!/bin/bash

# ##################################################
# upgrade script/v2
#
# HISTORY:
#
# Here it is. This is version two of my previously made upgrade script. Thanks for google's security feature as
# it made possible to authenticate my laptop into my google account using by application password. With this great
# possibility, I could implement to send an email about the happenings of the script.
# I installed a light-weight program, called sendemail, set up a few parameters with that as it shown below, set
# a cronjob and that is it, it works as expected: I get emails once a week!
#
# DATE: 19.06.2020
#
# Homepage https://github.com/SandorJokai/bash
#
# ##################################################


#Declare Variables
TORRENTS="/home/shanx/Downloads/*.torrent"
CAPACITY=`df /home | cut -d " " -f 6 | sed 's/.$//'`
LOG="/home/shanx/Dokumentumok/gyak/bash_examples/2020/upgrade.log"

echo "--------------------------------------------------------------------------------------------" >> upgrade.log
echo; echo "Report has made on: " `date` >> upgrade.log

#First thing is to find out whether is root or not.
#It is important when we run the script manually, but not using by cronjob.
if [ "$EUID" -ne 0 ]
then
	echo "You have no got permission to do that. Please, run this script with sudo or as root!" 2>&1 upgrade.log
	exit 0
else
	echo >> upgrade.log
	apt update && apt upgrade -y >> upgrade.log
fi


#In this section the script will be deleted all leftover torrent files.
LENGTH=`echo $TORRENTS | wc -c`
if [ $LENGTH -gt 35 ]
then
	for i in $TORRENTS;do
		rm -f $TORRENTS
	done
	echo >> upgrade.log
	echo -e "All torrent files has been deleted!\n" >> upgrade.log

fi

#Finally, this statement can shows us if the space is getting run out.
if [ $CAPACITY -ge 90 ]
then
	echo >> upgrade.log
	echo -e "Your home partition's capacity is more than 90%, it's time to save more space!\n" >> upgrade.log
fi

# send a report to my email
sendemail -l email.log -f shanx@shanx -u weekly report -t "myemail"@gmail.com -s smtp.gmail.com:587 -o tls=yes -xu "myemail"@gmail.com -xp "16bitlongapppassword" -m < upgrade.log
