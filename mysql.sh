#!/bin/bash

# The purpose of this script is to make a connection with a mysql database and
# that offers 3 options to the users after they typed the right password. Only
# those users can do that who has given permissions to the mysql's connection.
# The script has written by me, SANDOR JOKAI a.k.a. shanx
# You can feel free to use it, you are free to change and redistribute it.
# There is NO WARRANTY, to the extent permitted by law.
# Homepage https://github.com/SandorJokai/bash

clear

status=`systemctl status mysql | grep inactive`

if [[ $? = 0 ]]
then
	echo " The mysql service is not running, tell the sysadmin to launch it! "
	exit
else
	function mymain()
	{
		function DBConn() {
			if [ $count = 5 ]
			then
			echo; echo "You have typed a wrong password in 5 "
			echo "times OR you do not have permissions to "; echo "use the database at all! Good bye! "; echo
			exit
			fi }
		echo; echo -e "\e[34m How can I help you with? "
		echo " Adding new user (a) | remove a user (r) | information query (q) "; echo
		echo -n "Please use the appropriate keystroke! "
		read -a array
		count=1

		# This loop is run if the user do not type the right key between these options

		until [ $array = "q" -o $array = "a" -o $array = "r" ] 2> /dev/null
		do
			if [ $count = 5 ]
			then
				echo; echo " You have typed wrong key in 5 times, good bye! "; echo
			exit
			fi
			echo -n "Please use the appropriate keystroke! "
			read -a array
			count=$(( count + 1 ))
		done

		if [ $array = "q" ]
		then
			count=1
			echo
			echo "Please type the mysql password! "
			until mysql -u $USER -p --execute=" select * from teszt.emberek" 2> /dev/null
			do
				DBConn
				echo "You might have just mistyped. Please try it again! "
				count=$(( count + 1 ))
			done

		elif [ $array = "a" ]
		then
			function funcif()
			{
				if [ $count = 5 ]
				then
					echo; echo " You have typed wrong format in 5 times, good bye! "
					echo
					exit
				fi
			}
			count=1
			echo; echo -n " Please type the user's surname! "
			read sname

			# Here's a little regexp examination...
			# Minimum 3, max 25 long letters only with - character
			# if necessary, there is nothing else accepted.

			until [[ $sname =~ ^[a-zA-Z][a-zA-Z-]{2,25}$ ]]
			do
				funcif
				echo -n " Please use only letters in names! "
				read sname
				count=$(( count + 1 ))
			done
			count=1
			echo; echo -n " Please type the user's firstname! "
			read fname

			until [[ $fname =~ ^[a-zA-Z][a-zA-Z-]{2,25}$ ]]
			do
				funcif
				echo -n " Please use only letters in names! "
				read fname
				count=$(( count + 1 ))
			done
			count=1
			echo; echo -n " Please give now the user's email address! "
			read email

			until [[ $email =~ ^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}$ ]]
			do
				funcif
				echo -n " Please use a valid email address! "
				read email
				count=$(( count + 1 ))

			done
			count=1
			echo
			echo "Please type the mysql password! "
			until mysql -u $USER -p --execute="INSERT INTO teszt.emberek VALUES ( NULL, '$sname', '$fname', '$email' );" 2> /dev/null
			do
				DBConn
				echo "You might have just mistyped. Please try it again! "
				count=$(( count + 1 ))
			done

		fi

		if [ $array = "r" ]
		then
			echo -n " Please type the username's surname first that want to delete! "
			read delsname
			echo -n " Please type now the username's firstname! "
			read delfname
			echo; echo "Please type the mysql password! "
			until mysql -u $USER -p --execute="DELETE FROM teszt.emberek WHERE( vnev='$delsname' AND knev='$delfname' AND vnev IS NOT NULL AND knev IS NOT NULL);" > /dev/null 2>&1
			do
				break
			done
			until [ $? = 1 ]
			do
				echo; echo " There is no user with this name, or already has cancelled "; echo
				break
				mysql -u $USER -p --execute="DELETE FROM teszt.emberek WHERE( vnev='$delsname' AND knev='$delfname');" > /dev/null 2>&1
			done
		fi
	}
	mymain
	echo; echo -n " Is there anything I can help you with? Please hit (y) or (n) " 2> /dev/null
	read -a array

	while [ $array != "n" ] 2> /dev/null
	do
		mymain
		echo -n " Is there anything I can help you with? Please hit (y) or (n) " 2> /dev/null
		read -a array; echo
	done
	echo " Bye now, see you soon! "
	echo

fi
