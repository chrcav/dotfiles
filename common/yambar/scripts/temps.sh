#!/bin/bash

SLEEP_SEC=5
#loops forever outputting a line every SLEEP_SEC secs
HOST=$(hostname)
while :; do
	if [ "$HOST" == "bayesiandesktop" ]; then
		#spectrwm bar_print can't handle UTF-8 characters, such as degree symbol
		#Core 0:      +67.0°C  (crit = +100.0°C)
		cputemps=$(sensors coretemp-isa-0000 2>/dev/null)
		eval $(echo "$cputemps" | awk '/^Package id 0/ {printf "COREMAXTEMP=%s;", $4}; /^Core 0/ {printf "CORE0TEMP=%s;", $3};' -)
		cputemp="Tcpu=$COREMAXTEMP,$CORE0TEMP"
		eval $(sensors amdgpu-pci-0300 2>/dev/null | awk '/^fan1/ {printf "GPUFANSPD=%s;", $2}; /^edge/ {printf "GPUEDGETEMP=%s;", $2}; /^junction/ {printf "GPUJUNCTEMP=%s;",$2}; /^mem/ {printf "GPUMEMTEMP=%s;",$2};' -)
		gputemp="Tgpu=$GPUEDGETEMP,$GPUJUNCTEMP,$GPUMEMTEMP F=$GPUFANSPD"
	elif [ "$HOST" == "mntpocketr" ]; then
		cputemps=$(sensors cpu_thermal-virtual-0 2>/dev/null)
		eval $(echo "$cputemps" | awk '/^temp1/ {printf "CORETEMP=%s;", $2};' -)
		cputemp="Tcpu=$CORETEMP"
		soctemps=$(sensors soc_thermal-virtual-0 2>/dev/null)
		eval $(echo "$soctemps" | awk '/^temp1/ {printf "SOCTEMP=%s;", $2};' -)
		soctemp=",Tsoc=$SOCTEMP"
	fi

	echo "cputemp|string|$cputemp"
	echo "gputemp|string|$gputemp"
	echo "soctemp|string|$soctemp"
	echo ""
	sleep $SLEEP_SEC
done
