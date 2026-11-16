#!/bin/bash

#prompt for rofi menu 
#rofi_cmd="/home/wes/.config/rofi/launchers/type-1/style-3.rasi"

#time_minutes=$(echo "" | rofi -dmenu -p "Sleep in (minutes):" -theme $rofi_cmd)
time_minutes=$(echo "" | dmenu -p "Sleep in (minutes):")
#exit if nothing entered
[ -z "$time_minutes" ] && exit 1

#make sure its a number
if ! [[ "$time_minutes" =~ ^[0-9]+$ ]]; then
	notify-send "Sleep Timer" "Invalid number: $time_minutes"
	exit 1
fi

#convert to seconds
time_seconds=$((time_minutes * 60))
notify-send "Sleep Timer" "System will suspend in $time_minutes minutes(s)."
#wait
sleep "$time_seconds" && systemctl suspend

