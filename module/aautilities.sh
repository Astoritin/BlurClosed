VERIFY_DIR="$TMPDIR/.aa_bc_verify"
mkdir "$VERIFY_DIR"

install_env_check() {
  local MAGISK_BRANCH_NAME="Official"
  ROOT_SOL="Magisk"
  if [[ "$KSU" ]]; then
    logowl "Install from KernelSU"
    logowl "KernelSU version: $KSU_KERNEL_VER_CODE (kernel) + $KSU_VER_CODE (ksud)"
    ROOT_SOL="KernelSU (kernel:$KSU_KERNEL_VER_CODE, ksud:$KSU_VER_CODE)"
    if [[ "$(which magisk)" ]]; then
      logowl "Detect multiple Root implements!" "WARN"
      ROOT_SOL="Multiple"
    fi
  elif [[ "$APATCH" ]]; then
    logowl "Install from APatch"
    logowl "APatch version: $APATCH_VER_CODE"
    ROOT_SOL="APatch ($APATCH_VER_CODE)"
  elif [[ "$MAGISK_VER_CODE" || -n "$(magisk -v || magisk -V)" ]]; then
    MAGISK_V_VER_NAME="$(magisk -v)"
    MAGISK_V_VER_CODE="$(magisk -V)"
    if [[ "$MAGISK_VER" == *"-alpha"* || "$MAGISK_V_VER_NAME" == *"-alpha"* ]]; then
      MAGISK_BRANCH_NAME="Magisk Alpha"
    elif [[ "$MAGISK_VER" == *"-lite"* || "$MAGISK_V_VER_NAME" == *"-lite"* ]]; then
      MAGISK_BRANCH_NAME="Magisk Lite"
    elif [[ "$MAGISK_VER" == *"-kitsune"* || "$MAGISK_V_VER_NAME" == *"-kitsune"* ]]; then
      MAGISK_BRANCH_NAME="Kitsune Mask"
    elif [[ "$MAGISK_VER" == *"-delta"* || "$MAGISK_V_VER_NAME" == *"-delta"* ]]; then
      MAGISK_BRANCH_NAME="Magisk Delta"
    else
      MAGISK_BRANCH_NAME="Magisk"
    fi
    ROOT_SOL="$MAGISK_BRANCH_NAME (${MAGISK_VER_CODE:-$MAGISK_V_VER_CODE})"
    logowl "Install from $ROOT_SOL"
  else
    ROOT_SOL="Recovery"
    print_line
    logowl "Install module in Recovery mode is not support especially for KernelSU / APatch!" "FATAL"
    logowl "Please install this module in Magisk / KernelSU / APatch APP!" "FATAL"
    print_line
    abort
  fi
}

logowl() {

  local LOG_MSG="$1"
  local LOG_LEVEL="$2"

  if [ -z "$LOG_MSG" ]; then
    echo "! LOG_MSG is not provided yet!"
    return 3
  fi

  case "$LOG_LEVEL" in
    "TIPS")
      LOG_LEVEL="*"
      ;;
    "WARN")
      LOG_LEVEL="- Warn:"
      ;;
    "ERROR")
      LOG_LEVEL="! ERROR:"
      ;;
    "FATAL")
      LOG_LEVEL="× FATAL:"
      ;;
    *)
      LOG_LEVEL="-"
      ;;
  esac

  if [ -z "$LOG_FILE" ]; then
    if [ "$BOOTMODE" ]; then
        ui_print "$LOG_LEVEL $LOG_MSG" 2>/dev/null
        return 0
    fi
    echo "$LOG_LEVEL $LOG_MSG"
  else
    if [[ "$LOG_LEVEL" == "! ERROR:" ]] || [[ "$LOG_LEVEL" == "× FATAL:" ]]; then
      print_line
    fi
    echo "$LOG_LEVEL $LOG_MSG" >> "$LOG_FILE" 2>> "$LOG_FILE" 
    if [[ "$LOG_LEVEL" == "! ERROR:" ]] || [[ "$LOG_LEVEL" == "× FATAL:" ]]; then
      print_line
    fi
  fi
}

show_system_info() {
  logowl "Device: $(getprop ro.product.brand) $(getprop ro.product.model) ($(getprop ro.product.device))"
  logowl "Android $(getprop ro.build.version.release) (API $API), $ARCH"
  mem_info=$(free -m)
  ram_total=$(echo "$mem_info" | awk '/Mem/ {print $2}')
  ram_used=$(echo "$mem_info" | awk '/Mem/ {print $3}')
  ram_free=$((ram_total - ram_used))
  swap_total=$(echo "$mem_info" | awk '/Swap/ {print $2}')
  swap_used=$(echo "$mem_info" | awk '/Swap/ {print $3}')
  swap_free=$(echo "$mem_info" | awk '/Swap/ {print $4}')
  logowl "RAM Space: ${ram_total}MB  Used:${ram_used}MB  Free:${ram_free}MB"
  logowl "SWAP Space: ${swap_total}MB  Used:${swap_used}MB  Free:${swap_free}MB"
}

print_line() {
  local length=${1:-60}
  local line=$(printf "%-${length}s" | tr ' ' '-')
  echo "$line"
}

extract() {
  zip=$1
  file=$2
  dir=$3
  junk_paths=$4
  [ -z "$junk_paths" ] && junk_paths=false
  opts="-o"
  [ $junk_paths = true ] && opts="-oj"

  file_path=""
  hash_path=""
  if [ $junk_paths = true ]; then
    file_path="$dir/$(basename "$file")"
    hash_path="$VERIFY_DIR/$(basename "$file").sha256"
  else
    file_path="$dir/$file"
    hash_path="$VERIFY_DIR/$file.sha256"
  fi

  unzip $opts "$zip" "$file" -d "$dir" >&2
  [ -f "$file_path" ] || abort_verify "$file does not exist!"
  logowl "Extract $file -> $file_path" >&1

  unzip $opts "$zip" "$file.sha256" -d "$VERIFY_DIR" >&2
  [ -f "$hash_path" ] || abort_verify "$file.sha256 does not exist!"

  expected_hash="$(cat "$hash_path")"
  calculated_hash="$(sha256sum "$file_path" | cut -d ' ' -f1)"

  if [ "$expected_hash" == "$calculated_hash" ]; then
    logowl "Verified $file" >&1
  else
    abort_verify "Failed to verify $file"
  fi
}

set_module_files_perm() {
  logowl "Setting permissions"
  set_perm_recursive "$MODPATH" 0 0 0755 0644
}
