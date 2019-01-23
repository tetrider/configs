#!/bin/bash
while [[ ! $(pgrep plasmashell) ]]; do sleep 6; done
xinput set-prop 12 284 -1 -1 -1
xinput set-prop 13 284 -1 -1 -1
