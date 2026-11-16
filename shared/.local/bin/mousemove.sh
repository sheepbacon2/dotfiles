#!/bin/bash

# Base speed (pixels per keypress)
speed=7
fast_speed=50

while read -r key < /tmp/mousepipe; do
   # Check if shift is held (i3 sends uppercase letters when Shift is pressed)
   case "$key" in
      "W") xdotool mousemove_relative 0 -$fast_speed ;;
      "A") xdotool mousemove_relative -- -$fast_speed 0 ;;
      "S") xdotool mousemove_relative 0 $fast_speed ;;
      "D") xdotool mousemove_relative $fast_speed 0 ;;
      "w") xdotool mousemove_relative 0 -$speed ;;
      "a") xdotool mousemove_relative -- -$speed 0 ;;
      "s") xdotool mousemove_relative 0 $speed ;;
      "d") xdotool mousemove_relative $speed 0 ;;
      "Q") xdotool mousemove_relative -- -$fast_speed -$fast_speed ;;  
      "E") xdotool mousemove_relative $fast_speed -$fast_speed ;;
      "Z") xdotool mousemove_relative -- -$fast_speed $fast_speed ;;
      "C") xdotool mousemove_relative $fast_speed $fast_speed ;;
      "q") xdotool mousemove_relative -- -$speed -$speed ;;
      "e") xdotool mousemove_relative $speed -$speed ;;
      "z") xdotool mousemove_relative -- -$speed $speed ;;
      "c") xdotool mousemove_relative $speed $speed ;;
      "Return") xdotool click 1 ;;
      "rclick") xdotool click 3 ;;
      "mclick") xdotool click 2 ;;
   
      "sup") xdotool click 4 ;;
      "sdown") xdotool click 5 ;;
   
   esac
done

