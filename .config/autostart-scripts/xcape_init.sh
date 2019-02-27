#!/bin/bash
while [[ ! $(pgrep plasmashell) ]]; do sleep 5; done
setxkbmap -option ctrl:nocaps
xcape -e 'Control_L=Escape'

