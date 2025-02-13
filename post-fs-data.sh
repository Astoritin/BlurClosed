MODDIR=${0%/*}

if [ "`getprop ro.miui.ui.version.name`" != "" ]; then
resetprop -n ro.miui.has_real_blur 0
fi