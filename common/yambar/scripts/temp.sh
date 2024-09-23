#!/bin/bash

HOST=$(hostname)
sensor=$1
SLEEP_SEC=${2:-5}
IFS=$'\n'
group=
while :; do
	for line in $(sensors -u $sensor 2>/dev/null) ; do
		if [ ${line:0:6} = "  temp" ]; then
			eval $(echo "$line" | sed 's/://g' | awk '/^  temp/ {printf "name='%s';temp='%d';", $1, $2};' -)

			echo "${group}_${name}|int|$temp"
		else
			group=$(echo "$line" | sed 's/://g' | sed 's/ /_/g')
		fi 
	done
	echo ""

	sleep $SLEEP_SEC
done
