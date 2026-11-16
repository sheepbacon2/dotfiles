#!/bin/bash
option=$(echo -e "Shutdown\nReboot\nSuspend" | dmenu -l 3)
case $option in
	"Shutdown")
		systemctl poweroff	
		;;
	"Reboot")
		systemctl reboot
		;;
	"Suspend")
		systemctl suspend
		;;
	*)
		;;
esac
