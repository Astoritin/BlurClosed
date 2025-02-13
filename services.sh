MODDIR=${0%/*}

{
    until [[ "$(getprop sys.boot_completed)" == "1" ]]; do
    sleep 10
    done
    cmd window disable-blur 1
    wm disable-blur 1
}&