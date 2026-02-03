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

extract "customize.sh" "$TMPDIR" >/dev/null 2>&1

[ ! -d "$VERIFY_DIR" ] && mkdir -p "$VERIFY_DIR"

ui_print "- Setting up $MOD_NAME"
ui_print "- Version: $MOD_VER"
[ "$API" -lt 30 ] && {
    ui_print "- Detect Android 10-"
    ui_print "- $MOD_NAME may not work properly"
    ui_print "- Anyway, you can still have a try"
}
[ "$API" -ge "29" ] && cmd window disable-blur 1 || cmd wm disable-blur 1
extract "module.prop"
extract "post-fs-data.sh"
extract "uninstall.sh"
ui_print "- Setting permissions"
set_permission_recursive "$MODPATH" 0 0 0755 0644
ui_print "- Welcome to ${MOD_NAME}!"
