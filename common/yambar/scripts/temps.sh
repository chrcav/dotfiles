#!/bin/bash

SLEEP_SEC=5
#loops forever outputting a line every SLEEP_SEC secs
HOST=$(hostname)
while :; do
	if [ "$HOST" == "bayesiandesktop" ]; then
		#spectrwm bar_print can't handle UTF-8 characters, such as degree symbol
		#Core 0:      +67.0°C  (crit = +100.0°C)
		cputemps=$(sensors -u coretemp-isa-0000 2>/dev/null)
		eval $(echo "$cputemps" | awk '/temp1_input/ {printf "COREMAXTEMP=%s;", $2}; /^  temp2_input/ {printf "CORE0TEMP=%s;", $2};' -)
		cputemp="Tcpu=$COREMAXTEMP"
		eval $(sensors -u amdgpu-pci-0300 2>/dev/null | awk '/^  fan1_input/ {printf "GPUFANSPD=%s;", $2}; /^  temp1_input/ {printf "GPUEDGETEMP=%s;", $2}; /^  temp2_input/ {printf "GPUJUNCTEMP=%s;",$2}; /^  temp3_input/ {printf "GPUMEMTEMP=%s;",$2};' -)
		gputemp="Tgpu=$GPUEDGETEMP,$GPUJUNCTEMP,$GPUMEMTEMP"
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
