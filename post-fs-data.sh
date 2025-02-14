#!/system/bin/sh
MODDIR=${0%/*}

if [ "`getprop ro.miui.ui.version.name`" != "" ]; then
resetprop -n ro.miui.has_real_blur 0
fi
if [ "$API" -ge "31" ]; then
resetprop -n windowBlurBehindEnabled false
resetprop -n windowBlurBehindRadius 0
fi
