#!/bin/bash

clear

nu=$(( RANDOM % 100 ))
count=0

echo -n "Guess a number between 0 and 100! "
read x
echo

if [ $x = $nu ]
then
	echo "You have just find out, congratulations! "
	echo
fi

while [[ $x != $nu && $count < 6 ]]
do
	if [ $x -gt $nu ]
	then
		echo -n "You're guess is more than the number, try again with a smaller one! "
		read x
		echo
		count=$(( count+1 ))


	elif [ $x -lt $nu ]
	then
		echo -n "You're guess is less than the number, try again with a bigger one! "
		read x
		echo
		((count++))


	fi

	if [ $x = $nu ]
	then
		echo "You have just find out, congratulations! "
		echo
	fi

	if [[ $x -ne $nu && $count = 6 ]]
	then
		echo "So sorry, but you've guessed seven times badly, the random generated number was: $nu , good bye! "
		echo
	fi

done

