#!/bin/bash
echo "Choose an SSH target:" | 
echo "1) wes@ubuntu"
echo "2) wes@192.168.1.184"
read -rp "Enter choice [1-2]: " choice

case "$choice" in 
	1) 
		ssh wes@ubuntu
		;;
	2) 
		ssh wes@192.168.1.184
		;;
	*)
		echo "Invalid choice."
		exit 1
		;;
esac

