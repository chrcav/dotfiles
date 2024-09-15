#!/bin/sh

killall yambar
if [ "$(hostname)" = "mntpocketr" ]; then
	alt_config="-c $HOME/.config/yambar/laptop.yml"
fi
yambar $alt_config &
