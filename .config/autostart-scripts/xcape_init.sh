#!/bin/bash
while [[ ! $(pgrep plasmashell) ]]; do sleep 5; done
xcape -e 'Caps_Lock=Escape'

