#!/bin/sh

wlr-randr --output DSI-1 --transform 90 --scale 2.0
wlr-randr --output HDMI-A-1 --transform 270

pkill -f mpd
mpd

pkill -f yambar
yambar &

pkill -f swayidle
swayidle -w \
  timeout 300 'wlr-randr --output DSI-1 --off' resume 'wlr-randr --output DSI-1 --on' &
