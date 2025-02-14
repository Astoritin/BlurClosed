#!/system/bin/sh
MODDIR=${0%/*}

until [[ "$(getprop sys.boot_completed)" == "1" ]]; do
sleep 30
done

if [[ "$API" -ge "29" ]]; then
cmd window disable-blur 1
else
wm disable-blur 1
fi
