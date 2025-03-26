#!/system/bin/sh
MODDIR=${0%/*}

API="$(getprop ro.build.version.sdk)"

if [ "$API" -ge "29" ]; then
    cmd window disable-blur 1
    # settings put secure show_rotation_suggestions 0
else
    cmd wm disable-blur 1
fi
