#!/usr/bin/env bash

if [[ $1 == "fullscreen" ]]; then
    while pgrep -f kickoff > /dev/null; do
        sleep 0.05
    done
    geometry=""
else
    geometry="-g \"$(slurp -w 0)\" "
fi

if [[ $2 == "clipboard" ]]; then
    output="- | wl-copy"
else
    mkdir -p ~/Pictures/screenshots
    output="-t png -l 9 ~/Pictures/screenshots/$(date +%Y-%m-%d_%H:%M:%S).png"
fi

echo "grim -s 1.4 $geometry$output" | bash
