#!/usr/bin/env bash

temp="$(
    sensors |
    awk '/Tctl:/ {
        gsub(/^\+/, "", $2)
        gsub(/°C$/, "", $2)
        print $2
        exit
    }'
)"

# Nothing found
if [[ -z "$temp" ]]; then
    echo "N/A"
    echo "N/A"
    echo "#FFFFFF"
    exit 0
fi

# i3blocks line 1: full text
echo "${temp}°C"

# i3blocks line 2: short text
echo "${temp}°C"

# i3blocks line 3: color
if awk "BEGIN {exit !($temp >= 70)}"; then
    echo "#FF0000"
elif awk "BEGIN {exit !($temp >= 60)}"; then
    echo "#FFFC00"
else
    echo "#00FF00"
fi
