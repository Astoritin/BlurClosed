#!/system/bin/sh
MODDIR=${0%/*}

API=$(getprop ro.build.version.sdk)
DEVICE_BRAND=$(getprop ro.product.brand)
FLYME_VER_CODE=$(getprop ro.build.flyme.version)

if [ -n "$FLYME_VER_CODE" ] && [ $FLYME_VER_CODE -eq 8 ] ; then
    resetprop -n persist.perf.wm_static_blur false
    resetprop -n persist.sys.static_blur_mode false
    resetprop -n persist.vendor.sf.blur.type none
    resetprop -n persist.sys.disable_blur_view true
    resetprop -n persist.meizu.gpu_blur 0
    resetprop -n persist.sys.force_no_blur 0
fi

case "$DEVICE_BRAND" in
    "xiaomi")
        resetprop -n persist.sysui.miui_blur_enabled 0
        resetprop -n ro.miui.has_blur 0
        resetprop -n ro.miui.has_real_blur 0
        resetprop -n ro.miui.backdrop_sampling_enabled 0
        resetprop -n persist.miui.ui.optimize_blur 0
        ;;
    "oneplus")
        resetprop -n persist.sys.oneplus.blur.enabled 0
        resetprop -n persist.sys.oplus.ui.blur 0
        resetprop -n persist.sys.oppo.blur.enable 0
        ;;
    "samsung")
        resetprop -n persist.sys.samsung.blur.disable 1
        resetprop -n sys.use_frost_effect 0
        ;;
esac

if [ "$API" -ge "31" ]; then
    resetprop -n windowBlurBehindEnabled false
    resetprop -n windowBlurBehindRadius 0
    resetprop -n ro.surface_flinger.supports_background_blur 0
fi

