#!/bin/bash
# baraction.sh for spectrwm status bar

SLEEP_SEC=5
#loops forever outputting a line every SLEEP_SEC secs
while :; do
	#spectrwm bar_print can't handle UTF-8 characters, such as degree symbol
	#Core 0:      +67.0°C  (crit = +100.0°C)
	cputemps=$(sensors coretemp-isa-0000 2>/dev/null | sed s/[°+]//g)
	eval $(echo "$cputemps" | awk '/^Package id 0/ {printf "COREMAXTEMP=%s;", $4}; /^Core 0/ {printf "CORE0TEMP=%s;", $3};' -)
	TEMPSTR="Tcpu=$COREMAXTEMP,$CORE0TEMP"
	eval $(sensors amdgpu-pci-0300 2>/dev/null | sed s/[°+]//g | awk '/^fan1/ {printf "GPUFANSPD=%s;", $2}; /^edge/ {printf "GPUEDGETEMP=%s;", $2}; /^junction/ {printf "GPUJUNCTEMP=%s;",$2}; /^mem/ {printf "GPUMEMTEMP=%s;",$2};' -)
	TEMPSTR+=" | Tgpu=$GPUEDGETEMP,$GPUJUNCTEMP,$GPUMEMTEMP F=$GPUFANSPD"

	eval $(awk '/^MemTotal/ {printf "MTOT=%s;", $2}; /^MemAvailable/ {printf "MAVAIL=%s;",$2}; /^MemFree/ {printf "MFREE=%s;",$2}' /proc/meminfo)
	MUSED=$(( $MTOT - $MFREE ))
	MUSEDPT=$(( ($MUSED * 100) / $MTOT ))
	MAVAILPT=$(( ($MAVAIL * 100) / $MTOT ))
	MTOTMB=$(($MTOT / 1024))
	MEMSTR="MemAvail:${MAVAILPT}% MemUsed:${MUSEDPT}% MemTot:${MTOTMB}"

	MPCSTAT=$(mpc status 2>/dev/null | head -n 2)
	MPCSTAT=${MPCSTAT//$'\n'/;  }
	if [[ "$MPCSTAT" =~ "paused" ]]; then
		MPCSTAT="mpd paused"
	else
		MPCSTAT="mpd playing ${MPCSTAT%%; *}"
	fi
	MPDSTR="$MPCSTAT"

	TIMESTR=$(date '+%a %Y-%b-%d %H:%M:%S %Z')
	BATINFO=$(acpi 2>/dev/null)
	if [[ $? -ne 0 ]]; then
		echo -e "$TEMPSTR | $MEMSTR | $MPDSTR | $TIMESTR "
		xsetroot -name "$TEMPSTR | $MEMSTR | $MPDSTR | $TIMESTR"
	else
		echo -e "$TEMPSTR | $BATINFO | $MEMSTR | $MPDSTR | $TIMESTR "
		xsetroot -name "$TEMPSTR | $BATINFO | $MEMSTR | $MPDSTR | $TIMESTR"
	fi

	sleep $SLEEP_SEC
done
