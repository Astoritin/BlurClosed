#!/system/bin/sh

API=$(getprop ro.build.version.sdk)
blurstate=$(getprop ro.surface_flinger.supports_background_blur)

if [ "$blurstate" == "0" ] || [ -z "$blurstate" ]; then
echo "- Enabling blur effects..."
resetprop persist.sys.sf.disable_blurs false
resetprop persist.sys.background_blur_supported true
resetprop disableBlurs false
resetprop disableBackgroundBlur false
resetprop enable_blurs_on_windows 1
resetprop ro.launcher.blur.appLaunch 1
resetprop ro.sf.blurs_are_caro 0
resetprop ro.sf.blurs_are_expensive 1
resetprop ro.surface_flinger.supports_background_blur 1
if [ "`getprop ro.miui.ui.version.name`" != "" ]; then
resetprop ro.miui.has_real_blur 1
fi
if [ "$API" -ge "31" ]; then
resetprop windowBlurBehindEnabled true
resetprop windowBlurBehindRadius 20
fi
else
echo "- Disabling blur effects..."
resetprop persist.sys.sf.disable_blurs true
resetprop persist.sys.background_blur_supported false
resetprop disableBlurs true
resetprop disableBackgroundBlur true
resetprop enable_blurs_on_windows 0
resetprop ro.launcher.blur.appLaunch 0
resetprop ro.sf.blurs_are_caro 1
resetprop ro.sf.blurs_are_expensive 0
resetprop ro.surface_flinger.supports_background_blur 0
if [ "`getprop ro.miui.ui.version.name`" != "" ]; then
resetprop ro.miui.has_real_blur 0
fi
if [ "$API" -ge "31" ]; then
resetprop windowBlurBehindEnabled false
resetprop windowBlurBehindRadius 0
fi
fi

echo "- Restarting SystemUI..."
killall com.android.systemui
echo "- Restarting launcher..."
for launcher in \
    com.android.launcher3 \
    com.google.android.apps.nexuslauncher \
    com.sec.android.app.launcher \
    com.sec.android.app.twlauncher \
    com.huawei.android.launcher \
    com.coloros.home \
    com.realme.launcher \
    com.teslacoilsw.launcher \
    com.miui.home \
    com.microsoft.launcher
do
    killall $launcher
done
echo "- All done!"
