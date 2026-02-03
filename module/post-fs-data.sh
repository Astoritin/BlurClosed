#!/system/bin/sh
MODDIR=${0%/*}

API="$(getprop ro.build.version.sdk)"

check_and_resetprop() {
    local prop_name=$1
    local prop_expect_value=$2
    local prop_current_value=$(resetprop "$prop_name")

    [ -z "$prop_current_value" ] && return 1

    [ "$prop_current_value" = "$prop_expect_value" ] && return 0

    resetprop -n "$prop_name" "$prop_expect_value"

}

check_and_resetprop disableBlurs 1
check_and_resetprop disableBackgroundBlur 1
check_and_resetprop enable_blurs_on_windows 0
check_and_resetprop ro.launcher.blur.appLaunch 0
check_and_resetprop ro.sf.blurs_are_costly 1
check_and_resetprop ro.sf.blurs_are_expensive 1
check_and_resetprop ro.surface_flinger.force_disable_blur 1
check_and_resetprop persist.sys.sf.disable_blurs 1
check_and_resetprop persist.sys.background_blur_supported 0
check_and_resetprop persist.sys.background_blur_status_default 0
check_and_resetprop persist.sys.background_blur_version 0
check_and_resetprop persist.sys.add_blurnoise_supported 0
check_and_resetprop persist.sys.enable_third_blur 0
check_and_resetprop persist.sys.dynamic_blur_enabled 0
check_and_resetprop ro.surface_flinger.supports_background_blur 0
check_and_resetprop windowBlurBehindEnabled false
check_and_resetprop windowBlurBehindRadius 0
check_and_resetprop persist.sysui.miui_blur_enabled 0
check_and_resetprop ro.miui.has_blur 0
check_and_resetprop ro.miui.has_real_blur 0
check_and_resetprop ro.miui.backdrop_sampling_enabled 0
check_and_resetprop persist.miui.ui.optimize_blur 0
check_and_resetprop persist.sys.oneplus.blur.enabled 0
check_and_resetprop persist.sys.oplus.ui.blur 0
check_and_resetprop persist.sys.oppo.blur.enable 0
check_and_resetprop persist.sys.samsung.blur.disable 1
check_and_resetprop sys.use_frost_effect 0
check_and_resetprop persist.perf.wm_static_blur false
check_and_resetprop persist.sys.static_blur_mode true
check_and_resetprop persist.vendor.sf.blur.type none
check_and_resetprop persist.sys.disable_blur_view true
check_and_resetprop persist.meizu.gpu_blur 0
check_and_resetprop persist.sys.force_no_blur 0
check_and_resetprop persist.perf.wm_static_blur false
check_and_resetprop persist.sys.disable_blur_view true
check_and_resetprop persist.sys.disable_glass_blur true
check_and_resetprop persist.sys.static_blur_mode true

[ "$API" -ge "29" ] && cmd window disable-blur 1 || cmd wm disable-blur 1


