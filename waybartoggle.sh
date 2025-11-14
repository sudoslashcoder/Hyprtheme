#!/bin/bash

# This script toggles Waybar on/off

# Check if Waybar is running
if pgrep -x "waybar" > /dev/null
then
    echo "Disabling Waybar..."
    pkill waybar
else
    echo "Enabling Waybar..."
    waybar &
fi
