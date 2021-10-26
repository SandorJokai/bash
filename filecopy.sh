# This is a nice way of copying files between two machines over ssh

#!/bin/bash

source="$1"
destination="$2"

if [ $# != 2 ]
then
#  echo "You need to type the source and the destination IP adresses as arguments!"
  echo;echo "You need to type both the <src> IP's and the <dest> IP's!";echo
  exit 1
fi

array=(/root/filecopy /root/testfile)

for i in "${array[@]}"
do
#  `ssh root@$source "tar -cf compressed.tar $i"`
  ssh root@$source "tar -cf - $i" | ssh root@$destination "tar -xf - -C /"
done
