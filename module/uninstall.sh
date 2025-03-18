#!/system/bin/sh
MODDIR=${0%/*}

API="$(getprop ro.build.version.sdk)"

if [[ "$API" -ge "29" ]]; then
cmd window disable-blur 0
else
wm disable-blur 0
fi
