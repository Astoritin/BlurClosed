#!/system/bin/sh
SKIPUNZIP=1

MOD_PROP="${TMPDIR}/module.prop"
MOD_NAME="$(grep_prop name "$MOD_PROP")"
MOD_VER="$(grep_prop version "$MOD_PROP") ($(grep_prop versionCode "$MOD_PROP"))"

extract() {
    file="$1"
    dir="${2:-$MODPATH}"
    junk="${3:-false}"
    opts="-o"

    file_path="$dir/$file"  
    hash_path="$TMPDIR/$file.sha256"

    if [ "$junk" = true ]; then
        opts="-oj"
        file_path="$dir/$(basename "$file")"
        hash_path="$TMPDIR/$(basename "$file").sha256"
    fi

    file_dir="$(dirname $file_path)"
    mkdir -p "$file_dir" || abort "! Failed to create dir $dir!"

    unzip $opts "$ZIPFILE" "$file" -d "$dir" >&2
    [ -f "$file_path" ] || abort "! $file does NOT exist"

    unzip $opts "$ZIPFILE" "${file}.sha256" -d "$TMPDIR" >&2
    [ -f "$hash_path" ] || abort "! ${file}.sha256 does NOT exist"

    expected_hash="$(cat "$hash_path")"
    calculated_hash="$(sha256sum "$file_path" | cut -d ' ' -f1)"

    if [ "$expected_hash" == "$calculated_hash" ]; then
        ui_print "- Verified $file" >&1
    else
        abort "! Failed to verify $file"
    fi
}


[ ! -d "$VERIFY_DIR" ] && mkdir -p "$VERIFY_DIR"

echo "- Extract aa-util.sh"
unzip -o "$ZIPFILE" 'aa-util.sh' -d "$TMPDIR" >&2
if [ ! -f "$TMPDIR/aa-util.sh" ]; then
  echo "! Failed to extract aa-util.sh!"
  abort "! This zip may be corrupted!"
fi

. "$TMPDIR/aa-util.sh"

logowl "Setting up $MOD_NAME"
logowl "Version: $MOD_VER"
install_env_check
show_system_info
logowl "Install from $ROOT_SOL app"
logowl "Essential checks"

if [ "$API" -ge 30 ]; then
    logowl "Detect Android 11+"
else
    logowl "Detect Android 10-"
    logowl "$MOD_NAME may not work properly"
    logowl "Anyway, you can still have a try"
fi

extract "$ZIPFILE" 'aa-util.sh' "$VERIFY_DIR"
extract "$ZIPFILE" 'customize.sh' "$VERIFY_DIR"
logowl "Extract module files"
extract "$ZIPFILE" 'module.prop' "$MODPATH"
extract "$ZIPFILE" 'post-fs-data.sh' "$MODPATH"
extract "$ZIPFILE" 'uninstall.sh' "$MODPATH"
logowl "Set permission"
set_permission_recursive "$MODPATH" 0 0 0755 0644
logowl "Welcome to use ${MOD_NAME}!"
