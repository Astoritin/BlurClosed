#!/system/bin/sh
SKIPUNZIP=1
VERIFY_DIR="$TMPDIR/.aa_bc_verify"

MOD_NAME="$(grep_prop name "${TMPDIR}/module.prop")"
MOD_VER="$(grep_prop version "${TMPDIR}/module.prop") ($(grep_prop versionCode "${TMPDIR}/module.prop"))"

check_android_api(){
  if [ "$API" -eq 30 ]; then
  logowl "Detect Android 11"
  elif [ "$API" -ge 31 ]; then
  logowl "Detect Android 12+"
  else
  logowl "Detect Android version is lower than Android 11" "WARN"
  logowl "This module may not work properly in your ROM" "WARN"
  logowl "Anyway, some ROMs backport these props and support the same features" "TIPS"
  logowl "Don't worry, you can still have a try" "TIPS"
  fi
}

add_additional_props(){

  local API="$(getprop ro.build.version.sdk)"
  local MIUI_VER_CODE="$(getprop ro.miui.ui.version.code)"
  local HYPEROS_VER_CODE="$(getprop ro.mi.os.version.code)"

  if [ -n "$MIUI_VER_CODE" ] || [ -n "$HYPEROS_VER_CODE" ]; then
    logowl "Detect MIUI/HyperOS"
    echo "ro.miui.backdrop_sampling_enabled=false" >> "$MODPATH/system.prop"
    echo "ro.miui.has_real_blur=0" >> "$MODPATH/system.prop"
    echo "ro.miui.has_blur=0" >> "$MODPATH/system.prop"
    logowl "Set additional props for Xiaomi/Redmi"
  fi

  if [ "$API" -ge "31" ]; then
    echo "windowBlurBehindEnabled=false" >> "$MODPATH/system.prop"
    echo "windowBlurBehindRadius=0" >> "$MODPATH/system.prop"
    echo "ro.surface_flinger.supports_background_blur=1" >> "$MODPATH/system.prop"
    logowl "Set additional props for Android 11+"
  fi

}

logowl "Extract aautilities.sh"
unzip -o "$ZIPFILE" 'aautilities.sh' -d "$TMPDIR" >&2
if [ ! -f "$TMPDIR/aautilities.sh" ]; then
  logowl "! Failed to extract aautilities.sh!"
  abort "! This zip may be corrupted!"
fi

. "$TMPDIR/aautilities.sh"

logowl "Setting up $MOD_NAME"
logowl "Version: $MOD_VER"
show_system_info
install_env_check
check_android_api
logowl "Extract module files"
extract "$ZIPFILE" 'module.prop' "$MODPATH"
extract "$ZIPFILE" 'system.prop' "$MODPATH"
extract "$ZIPFILE" 'service.sh' "$MODPATH"
extract "$ZIPFILE" 'uninstall.sh' "$MODPATH"
add_additional_props
set_module_files_perm
logowl "Welcome to use ${MODNAME}!"
