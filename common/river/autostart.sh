#!/bin/sh

wlr-randr --output DSI-1 --transform 90 --scale 2.0
wlr-randr --output HDMI-A-1 --transform 270

pkill -f mpd
mpd

pkill -f swaybg
swaybg -m fill -i ~/.cache/wallpaper &


pkill -f yambar
~/.config/yambar/scripts/start.sh

pkill -f swayidle
swayidle -w \
  timeout 300 'wlopm --off \*' resume 'wlopm --on \*' &
