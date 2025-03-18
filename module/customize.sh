#!/system/bin/sh
SKIPUNZIP=1
VERIFY_DIR="$TMPDIR/.aa_verify"

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

if [ ! -d "$VERIFY_DIR" ]; then
    mkdir -p "$VERIFY_DIR"
fi

echo "- Extract aautilities.sh"
unzip -o "$ZIPFILE" 'aautilities.sh' -d "$TMPDIR" >&2
if [ ! -f "$TMPDIR/aautilities.sh" ]; then
  echo "! Failed to extract aautilities.sh!"
  abort "! This zip may be corrupted!"
fi

. "$TMPDIR/aautilities.sh"

logowl "Setting up $MOD_NAME"
logowl "Version: $MOD_VER"
install_env_check
check_android_api
show_system_info
logowl "Essential checks"
extract "$ZIPFILE" 'aautilities.sh' "$VERIFY_DIR"
extract "$ZIPFILE" 'customize.sh' "$VERIFY_DIR"
logowl "Extract module files"
extract "$ZIPFILE" 'module.prop' "$MODPATH"
extract "$ZIPFILE" 'post-fs-data.sh' "$MODPATH"
extract "$ZIPFILE" 'service.sh' "$MODPATH"
rm -rf "$VERIFY_DIR"
set_module_files_perm
logowl "Welcome to use ${MODNAME}!"
