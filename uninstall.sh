#!/system/bin/sh
MODDIR=${0%/*}

if [[ "$API" -ge "29" ]]; then
cmd window disable-blur 0
else
wm disable-blur 0
fi
