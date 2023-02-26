#!/bin/bash
# Basic script to kill all old bars and launch new.

# Terminate already running bad instances
killall -q polybar

# Launch the bar on all monitors
for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload main_bar &
done
