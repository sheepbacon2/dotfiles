#!/usr/bin/env bash

MODE1="DPY-3: 3840x2160 @3840x2160 +0+0 {ViewPortIn=3840x2160, ViewPortOut=3840x2160+0+0}, DPY-5: 1920x1080_165 @3840x2160 +3840+0 {ViewPortIn=3840x2160, ViewPortOut=1920x1080+0+0}"
#MODE2="DPY-3: 3840x2160 @2160x3840 +0+0 {ViewPortIn=2160x3840, ViewPortOut=3840x2160+0+0, Rotation=270}, DPY-5: 1920x1080_165 @3840x2160 +2160+0 {ViewPortIn=3840x2160, ViewPortOut=1920x1080+0+0}"
MODE2="DPY-3: 3840x2160 +0+0 {Rotation=270}, DPY-5: 1920x1080_165 @3840x2160 +3840+0 {ViewPortIn=3840x2160, ViewPortOut=1920x1080+0+0}"
current=$(nvidia-settings --query CurrentMetaMode | sed -n 's/.*:: //p')

if [[ "$current" == "$MODE1" ]]; then
    nvidia-settings --assign CurrentMetaMode="$MODE2"
else
    nvidia-settings --assign CurrentMetaMode="$MODE1"
fi
