#!/bin/bash
while [[ ! $(pgrep plasmashell) ]]; do sleep 8; done
while [[ ! $(pgrep yakuake) ]]; do sleep 1; done
xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $(xdotool search --pid $(pidof yakuake))
