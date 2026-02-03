#!/system/bin/sh
MODDIR=${0%/*}

API="$(getprop ro.build.version.sdk)"

[ "$API" -ge "29" ] && cmd window disable-blur 0 || cmd wm disable-blur 0