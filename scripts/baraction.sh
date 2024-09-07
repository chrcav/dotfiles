#!/bin/bash
# baraction.sh for spectrwm status bar

SLEEP_SEC=5
#loops forever outputting a line every SLEEP_SEC secs
HOST=$(hostname)
while :; do
	if [ "$HOST" == "bayesiandesktop" ]; then
		#spectrwm bar_print can't handle UTF-8 characters, such as degree symbol
		#Core 0:      +67.0°C  (crit = +100.0°C)
		cputemps=$(sensors coretemp-isa-0000 2>/dev/null | sed s/[°+]//g)
		eval $(echo "$cputemps" | awk '/^Package id 0/ {printf "COREMAXTEMP=%s;", $4}; /^Core 0/ {printf "CORE0TEMP=%s;", $3};' -)
		TEMPSTR="Tcpu=$COREMAXTEMP,$CORE0TEMP"
		eval $(sensors amdgpu-pci-0300 2>/dev/null | sed s/[°+]//g | awk '/^fan1/ {printf "GPUFANSPD=%s;", $2}; /^edge/ {printf "GPUEDGETEMP=%s;", $2}; /^junction/ {printf "GPUJUNCTEMP=%s;",$2}; /^mem/ {printf "GPUMEMTEMP=%s;",$2};' -)
		TEMPSTR+=" | Tgpu=$GPUEDGETEMP,$GPUJUNCTEMP,$GPUMEMTEMP F=$GPUFANSPD"
	elif [ "$HOST" == "mntpocketr" ]; then
		cputemps=$(sensors cpu_thermal-virtual-0 2>/dev/null | sed s/[°+]//g)
		eval $(echo "$cputemps" | awk '/^temp1/ {printf "CORETEMP=%s;", $2};' -)
		TEMPSTR="Tcpu=$CORETEMP"
		soctemps=$(sensors soc_thermal-virtual-0 2>/dev/null | sed s/[°+]//g)
		eval $(echo "$soctemps" | awk '/^temp1/ {printf "SOCTEMP=%s;", $2};' -)
		TEMPSTR+=",Tsoc=$SOCTEMP"
	fi

	WTTR=$(cat /tmp/wttr)

	eval $(awk '/^MemTotal/ {printf "MTOT=%s;", $2}; /^MemFree/ {printf "MFREE=%s;",$2}' /proc/meminfo)
	MUSED=$(( $MTOT - $MFREE ))
	MUSEDPT=$(( ($MUSED * 100) / $MTOT ))
	MTOTMB=$(( MTOT / 1024 ))

	if [ "$HOST" == "bayesiandesktop" ]; then
		MEMSTR="MemUsed ${MUSEDPT}% MemTot:${MTOTMB}"
	elif [ "$HOST" == "mntpocketr" ]; then
		MEMSTR="Mem:${MUSEDPT}%"
	fi

	MPCSTAT=$(mpc status 2>/dev/null | head -n 2)
	MPCSTAT=${MPCSTAT//$'\n'/;  }
	if [[ "$MPCSTAT" =~ "paused" ]]; then
		MPCSTAT="mpd paused"
	elif [[ "$MPCSTAT" =~ "volume: n/a" ]]; then
		MPCSTAT="mpd playlist empty"
	else
		MPCSTAT="mpd playing ${MPCSTAT%%; *}"
	fi
	MPDSTR="$MPCSTAT"

	if [ "$HOST" == "bayesiandesktop" ]; then
		TIMESTR=$(date '+%a %Y-%b-%d %H:%M:%S %Z')
	elif [ "$HOST" == "mntpocketr" ]; then
		TIMESTR=$(date '+%y-%b-%d %H:%M:%S %Z')
	fi
	if [ "$HOST" == "mntpocketr" ]; then
		BATINFO=$(acpi 2>/dev/null)
	fi
	if [ "$HOST" == "bayesiandesktop" ]; then
		BARLINE="$TEMPSTR | $MEMSTR | $MPDSTR | $WTTR | $TIMESTR "
	elif [ "$HOST" == "mntpocketr" ]; then
		BARLINE="$TEMPSTR | $BATINFO | $MEMSTR | $MPDSTR | $WTTR | $TIMESTR "
	fi
	echo -e "$BARLINE"
	if [ -f /usr/bin/xsetroot ]; then
		xsetroot -name "$BARLINE"
	fi

	sleep $SLEEP_SEC
done
