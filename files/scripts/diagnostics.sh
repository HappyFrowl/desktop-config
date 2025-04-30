#! /usr/bin/env bash

# Power usage
POWER=$(upower -i $(upower -e | grep 'BAT') | grep energy-rate | cut -d: -f2 | xargs)
echo "Current power consumption is: $POWER"

# CPU usage


# Memory usage


# Disk usage






