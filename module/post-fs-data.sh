#!/system/bin/sh
MODDIR=${0%/*}

API="$(getprop ro.build.version.sdk)"
DEVICE_BRAND="$(getprop ro.product.brand | tr 'A-Z' 'a-z')"

resetprop disableBlurs 1
resetprop disableBackgroundBlur 1
resetprop enable_blurs_on_windows 0
resetprop ro.launcher.blur.appLaunch 0
resetprop ro.sf.blurs_are_costly 1
resetprop ro.sf.blurs_are_expensive 1
resetprop ro.surface_flinger.force_disable_blur 1
resetprop persist.sys.sf.disable_blurs 1
resetprop persist.sys.background_blur_supported 0
resetprop persist.sys.background_blur_status_default 0
resetprop persist.sys.background_blur_version 0
resetprop persist.sys.add_blurnoise_supported 0
resetprop persist.sys.enable_third_blur 0
resetprop persist.sys.dynamic_blur_enabled 0

if [ "$API" -ge "31" ]; then
    resetprop ro.surface_flinger.supports_background_blur 0
    resetprop windowBlurBehindEnabled false
    resetprop windowBlurBehindRadius 0
fi

if [ "$API" -ge "29" ]; then
    cmd window disable-blur 1
else
    cmd wm disable-blur 1
fi

if [ "$DEVICE_BRAND" = "xiaomi" ]; then

    miui_ver=$(getprop ro.miui.ui.version.code)
    hyper_ver=$(getprop ro.mi.os.version.code)
    
    if [ "$miui_ver" ] && [ -z "$hyper_ver" ]; then
        resetprop persist.sysui.miui_blur_enabled 0
        resetprop ro.miui.has_blur 0
        resetprop ro.miui.has_real_blur 0
        resetprop ro.miui.backdrop_sampling_enabled 0
        resetprop persist.miui.ui.optimize_blur 0
    fi

elif [ "$DEVICE_BRAND" = "oneplus" ]; then

    resetprop persist.sys.oneplus.blur.enabled 0
    resetprop persist.sys.oplus.ui.blur 0
    resetprop persist.sys.oppo.blur.enable 0

elif [ "$DEVICE_BRAND" = "samsung" ]; then

    resetprop persist.sys.samsung.blur.disable 1
    resetprop sys.use_frost_effect 0

elif [ "$DEVICE_BRAND" = "meizu" ]; then

    flyme_ver="$(getprop ro.build.flyme.version)"

    if [ "$flyme_ver" -eq 8 ]; then
        resetprop persist.perf.wm_static_blur false
        resetprop persist.sys.static_blur_mode true
        resetprop persist.vendor.sf.blur.type none
        resetprop persist.sys.disable_blur_view true
        resetprop persist.meizu.gpu_blur 0
        resetprop persist.sys.force_no_blur 0
    elif [ "$flyme_ver" -eq 7 ]; then
        resetprop persist.perf.wm_static_blur false
        resetprop persist.sys.disable_blur_view true
        resetprop persist.sys.disable_glass_blur true
        resetprop persist.sys.static_blur_mode true
    fi

fi

