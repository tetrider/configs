#!/bin/bash
while [[ ! $(pgrep plasmashell) ]]; do sleep 6; done
# xinput set-prop 12 284 -1 -1 -1
# xinput set-prop 13 284 -1 -1 -1
xinput set-prop 9 278 -1 -1 -1
xinput set-prop 10 278 -1 -1 -1
xinput set-prop 15 278 -1 -1 -1
