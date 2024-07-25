#!/usr/bin/env bash
# Basic script to kill all old bars and launch new.

# Terminate already running bad instances
killall -q polybar

PRIMARY=$(polybar --list-monitors | grep "primary" | cut -d":" -f1)
OTHERS=$(polybar --list-monitors | grep -v "primary" | cut -d":" -f1)

MONITOR=$PRIMARY TRAY=right polybar --reload main_bar &
sleep 1

# Launch the bar on all monitors
for m in $OTHERS; do
    MONITOR=$m polybar --reload main_bar &
done
