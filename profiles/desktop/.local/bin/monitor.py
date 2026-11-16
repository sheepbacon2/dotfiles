#!/usr/bin/env python3
import os
from pathlib import Path
import subprocess

def get_layout(mode):
    for line in mode.splitlines():
        if "::" in line:
            return line.split(":: ", 1)[1].strip()

with open(Path.home() / ".local/bin/monitor_layouts/mode1.txt", "r") as f:
    MODE1 = get_layout(f.read())

with open(Path.home() / ".local/bin/monitor_layouts/mode2.txt", "r") as f:
    MODE2 = get_layout(f.read())
    MODE2 = MODE2.replace("ViewPortIn=2160x3840, ViewPortOut=3840x2160+0+0, ", "")



def get_current_mode():
    result = subprocess.run(
        ["nvidia-settings", "--query", "CurrentMetaMode"],
        capture_output=True,
        text=True
    )

    # Extract the part after ":: "
    for line in result.stdout.splitlines():
        if "::" in line:
            return line.split(":: ", 1)[1].strip()

    return ""


def set_mode(mode):
    subprocess.run([
        "nvidia-settings",
        "--assign",
        f"CurrentMetaMode={mode}"
    ])


def main():
    current = get_current_mode()

    if current == MODE1:
        set_mode(MODE2)
    else:
        set_mode(MODE1)


if __name__ == "__main__":
    main()
