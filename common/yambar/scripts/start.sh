#!/bin/sh

killall yambar
if [ "$(hostname)" = "mntpocketr" ]; then
	alt_config="-c $HOME/.config/yambar/laptop.yml"
fi
monitors=$(wlr-randr | grep "^[^ ]" | awk '{ print$1 }')
total=$(wlr-randr | grep "^[^ ]" | awk '{ print$1 }' | wc -l)

if [ "$total" -gt "1" ]; then
	for monitor in ${monitors}; do
		if [ "$monitor" != "DP-1" ]; then
			riverctl focus-output ${monitor}
			yambar -c "$HOME/.config/yambar/condensed.yml" &
			sleep 0.2
		fi
	done
	riverctl focus-output DP-1
fi

yambar $alt_config &
