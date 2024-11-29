#!/bin/bash

# Kill all existing Polybar instannces
killall -q polybar

# Start a new instance
polybar mybar 2>&1 | tee -a /tmp/polybar.log  & disown

# Logging message
echo "Polybar Launched..."
