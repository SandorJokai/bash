#!/bin/bash

pdb.rb linweb{{01..52},{250,251}}-new -c "hostname;df -h /home" > file.out 2>/dev/null

input="file.out"
while IFS= read -r line
do
	sed -e '/^10/d' -e '/^File/d' | paste -d, - - | sort -n | uniq > file2.out

done < "$input"
rm file.out

awk '{ print $1 " "$2 " "$5 }' file2.out | sort -n -k1.7 | sed -r 's/-new.linvh1.fasthosts.co.uk,/-new /' > file3.out
rm file2.out

cat file3.out | awk 'BEGIN { printf "%-12s %-4s %-16s\n", "HOSTNAME", "TOTAL", "USAGE" } { print $1 "  "$3 "  "$4 }'

rm file3.out

