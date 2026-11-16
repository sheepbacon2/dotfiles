#!/bin/bash

read -rp "Enter script name: " script_name
if [ -z "$script_name" ]; then
	echo "No script name entered. Exiting."
	exit 1
fi

script_path="$HOME/.local/bin/$script_name"

#create or edit file if it already exists
nvim "$script_path"

#make it executable
chmod +x "$script_path"
echo "Created script and made executable: $script_path"

