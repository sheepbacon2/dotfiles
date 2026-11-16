#!/usr/bin/env bash

TARGET_CLASS="org.vinegarhq.Sober"

INTERVAL_MINUTES=9.5
INTERVAL_SECONDS=$(awk "BEGIN {print int($INTERVAL_MINUTES * 60)}")

SPACE_REPEAT=10
SPACE_DELAY_MS=100    
FOCUS_DELAY=0.3
RESTORE_DELAY=0.3

countdown() {
    local seconds="$1"

    while [ "$seconds" -gt 0 ]; do
        printf "\rNext action in: %02d:%02d " "$((seconds / 60))" "$((seconds % 60))"
        sleep 1
        seconds=$((seconds - 1))
    done

    printf "\rNext action now...        \n"
}

while true; do
    if ! i3-msg -t get_tree | grep -q "\"class\":\"$TARGET_CLASS\""; then
        echo "Window not found: $TARGET_CLASS"
        countdown "$INTERVAL_SECONDS"
        continue
    fi

    i3-msg -q 'mark --replace previous_window'
    i3-msg -q "[class=\"$TARGET_CLASS\"] focus"

    sleep "$FOCUS_DELAY"

    xdotool key --repeat "$SPACE_REPEAT" --delay "$SPACE_DELAY_MS" space

    sleep "$RESTORE_DELAY"

    i3-msg -q '[con_mark="previous_window"] focus'
    i3-msg -q 'unmark previous_window'

    countdown "$INTERVAL_SECONDS"
done
