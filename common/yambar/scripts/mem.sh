#!/bin/bash
# baraction.sh for spectrwm status bar

SLEEP_SEC=5
#loops forever outputting a line every SLEEP_SEC secs
HOST=$(hostname)
while :; do
	eval $(awk '/^MemTotal/ {printf "memtotal=%s;", $2}; /^MemFree/ {printf "memfree=%s;",$2}' /proc/meminfo)
	memused=$(( $memtotal - $memfree ))
	memusedpct=$(( ($memused * 100) / $memtotal ))

	echo "memused|int|$memused"
	echo "memusedpct|int|$memusedpct"
	echo "memfree|int|$memfree"
	echo "memtotal|int|$memtotal"
	echo "mem|range:0-$memtotal|$memused"
	echo ""

	sleep $SLEEP_SEC
done
