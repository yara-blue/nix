#!/usr/bin/env bash

set -e

desktops=$(kickoff-dot-desktop)
screenshot="\
	Area to clipboard = screenshot.sh area clipboard
	Area to file = screenshot.sh area file
	Fullscreen to clipboard = screenshot.sh fullscreen clipboard
	Fullscreen to file = screenshot.sh fullscreen file
	Edit clipboard image = wl-paste | swappy -f -
"
record="\
	Record area (mod+x to stop) = record_screen.sh start area
	Record fullscreen (mod+x to stop) = record_screen.sh start fullscreen
	Recording gif to clipboard = to_gif.sh
	Recording mp4 to clipboard = wl-copy < /tmp/last_record_screen.mp4
"

echo "${screenshot}${record}${desktops}" | kickoff --from-stdin
