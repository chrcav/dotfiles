#!/bin/bash
# baraction.sh for spectrwm status bar

SLEEP_SEC=5
#loops forever outputting a line every SLEEP_SEC secs
while :; do
	#spectrwm bar_print can't handle UTF-8 characters, such as degree symbol
	#Core 0:      +67.0°C  (crit = +100.0°C)
	eval $(sensors 2>/dev/null | sed s/[°+]//g | awk '/^Core 0/ {printf "CORE0TEMP=%s;", $3}; /^Core 1/ {printf "CORE1TEMP=%s;",$3}; /^Core 2/ {printf "CORE2TEMP=%s;",$3}; /^Core 3/ {printf "CORE3TEMP=%s;",$3}; /^fan1/ {printf "FANSPD=%s;",$2};' -)
	TEMP_STR="Tcpu=$CORE0TEMP,$CORE1TEMP,$CORE2TEMP,$CORE3TEMP F=$FANSPD"

	eval $(awk '/^MemTotal/ {printf "MTOT=%s;", $2}; /^MemAvailable/ {printf "MAVAIL=%s;",$2}; /^MemFree/ {printf "MFREE=%s;",$2}' /proc/meminfo)
	MUSED=$(( $MTOT - $MFREE ))
	MUSEDPT=$(( ($MUSED * 100) / $MTOT ))
	MAVAILPT=$(( ($MAVAIL * 100) / $MTOT ))
	MTOTMB=$(($MTOT / 1024))
	MEM_STR="MemAvail:${MAVAILPT}% MemUsed:${MUSEDPT}% MemTot:${MTOTMB}"

  MPCSTAT=$(mpc status 2>/dev/null | head -n 2)
  MPCSTAT=${MPCSTAT//$'\n'/;  }
  MPDSTR="$MPCSTAT"

	echo -e "$TEMP_STR $MEM_STR        $MPDSTR"
  xsetroot -name "$TEMP_STR $MEM_STR $MPDSTR"

	sleep $SLEEP_SEC
done
