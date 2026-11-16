#!/bin/bash

SLOT="$1"
FILE="$HOME/.mousepos${SLOT}"

# If no saved pos, notify
if [[ ! -f "$FILE" ]]; then
    notify-send "No mouse position" "Slot $SLOT is empty."
    exit 1
fi

# Load X / Y
read X Y < "$FILE"

# Move and click without affecting focus
xdotool mousemove $X $Y
#sleep .1
xdotool click --delay 0 1
