#!/system/bin/sh

if [[ "$API" -ge "29" ]]; then
    blurstate=$(cmd window disable-blur)
    if [[ "$blurstate" -eq "1" ]]; then
        cmd window disable-blur 0
    else
        cmd window disable-blur 1
    fi
else
    blurstate=$(wm disable-blur)
    if [[ "$blurstate" -eq "1" ]]; then
        wm disable-blur 0
    else
        wm disable-blur 1
    fi
fi

# blurstate1=$(getprop persist.sys.sf.disable_blurs)
# blurstate2=$(getprop persist.sys.background_blur_supported)

#if [[ "$blurstate1" == "true" || "$blurstate2" == "false" ]]; then
#    resetprop -n persist.sys.sf.disable_blurs false
#    resetprop -n persist.sys.background_blur_supported true
#    resetprop -n disableBlurs false
#    resetprop -n disableBackgroundBlur false
#    resetprop -n enable_blurs_on_windows 1
#    resetprop -n ro.launcher.blur.appLaunch 1
#    resetprop -n ro.sf.blurs_are_caro 0
#    resetprop -n ro.sf.blurs_are_expensive 1
#    resetprop -n ro.surface_flinger.supports_background_blur 1
#else
#    resetprop -n persist.sys.sf.disable_blurs true
#    resetprop -n persist.sys.background_blur_supported false
#    resetprop -n disableBlurs true
#    resetprop -n disableBackgroundBlur true
#    resetprop -n enable_blurs_on_windows 0
#    resetprop -n ro.launcher.blur.appLaunch 0
#    resetprop -n ro.sf.blurs_are_caro 1
#    resetprop -n ro.sf.blurs_are_expensive 0
#    resetprop -n ro.surface_flinger.supports_background_blur 0
#fi

#stop surfaceflinger
#start surfaceflinger

