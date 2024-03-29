# This script can fetch information from multiple servers via ansible. The company where I work use puppet, so the "pdb" command is
# run puppet database where all the datas come from. In order to use the script from everywhere, I created the file called file.out,
# running absolutely the same command like in line 7.

#!/bin/bash

#pdb.rb linweb{{01..52},{250,251}}-new -c "hostname;df -h /home" > file.out 2>/dev/null

input="file.out"
while IFS= read -r line
do
	sed -e '/^1/d' -e '/^File/d' | paste -d, - - | sort -n | uniq > file2.out

done < "$input"
rm file.out

awk '{ print $1 " "$2 " "$5 }' file2.out | sort -n -k1.9 > file3.out
rm file2.out

cat file3.out | awk 'BEGIN { printf "%-12s %-4s %-16s\n", "HOSTNAME", "TOTAL", "USAGE" } { print $1 "  "$3 "  "$4 }'

rm file3.out

