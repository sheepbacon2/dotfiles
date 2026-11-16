#!/usr/bin/env python3
import subprocess
from pathlib import Path

path = str(Path.home() / ".config/picom.conf")


with open(path, "r") as f:
    lines = f.readlines()

for i, line in enumerate(lines):
    if line.strip().startswith("vsync"):
        if "true" in line:
            lines[i] = "vsync = false;\n"
            vsync_state = "OFF"
        else:
            lines[i] = "vsync = true;\n"
            vsync_state = "ON"

with open(path, "w") as f:
    f.writelines(lines)
subprocess.run(["notify-send", f"Vsync {vsync_state}"])
