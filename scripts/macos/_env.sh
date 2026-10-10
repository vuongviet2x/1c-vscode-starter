#!/usr/bin/env bash
# Đọc 1c.env và chuẩn bị biến + hàm dùng chung. Các script khác: source "$(dirname "$0")/_env.sh"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SRC="$ROOT/src/cf"
LOGDIR="$ROOT/logs"
mkdir -p "$LOGDIR"

load_env() {
  if [ ! -f "$ROOT/1c.env" ]; then
    echo "[LỖI] Chưa có file 1c.env. Chạy scripts/macos/doctor.sh (tự tạo) hoặc: cp 1c.env.example 1c.env"
    return 1
  fi
  V8_VERSION=""; V8_PATH=""; IB_PATH=""; IB_USER=""; IB_PWD=""; UI_LANG=""
  while IFS='=' read -r key val || [ -n "$key" ]; do
    key="$(printf '%s' "$key" | tr -d '[:space:]')"
    case "$key" in ''|\#*) continue ;; esac
    val="${val%$'\r'}"
    printf -v "$key" '%s' "$val"
  done < "$ROOT/1c.env"
  UI_LANG="${UI_LANG:-en}"
  IB_PATH="${IB_PATH:-ib}"

  # --- Tìm 1cv8 (Designer) ---
  if [ -z "$V8_PATH" ]; then
    for c in \
      "/Applications/1cv8.localized/$V8_VERSION/1cv8.app/Contents/MacOS/1cv8" \
      "/Applications/1cv8/$V8_VERSION/1cv8.app/Contents/MacOS/1cv8" \
      "/opt/1cv8/x86_64/$V8_VERSION/1cv8" \
      "/opt/1cv8/aarch64/$V8_VERSION/1cv8"; do
      if [ -x "$c" ]; then V8_PATH="$c"; break; fi
    done
  fi
  if [ ! -x "$V8_PATH" ]; then
    echo "[LỖI] Không tìm thấy 1cv8 của platform $V8_VERSION."
    echo "      Kiểm tra V8_VERSION trong 1c.env, hoặc điền đường dẫn đầy đủ vào V8_PATH."
    echo "      Gợi ý tìm: ls -d /Applications/1cv8*/*/1cv8.app"
    return 1
  fi
  V8C_PATH="$(dirname "$V8_PATH")/1cv8c"
  if [ ! -x "$V8C_PATH" ]; then
    # macOS: 1cv8c.app nằm cạnh 1cv8.app
    V8C_PATH="$(cd "$(dirname "$V8_PATH")/../../.." 2>/dev/null && pwd)/1cv8c.app/Contents/MacOS/1cv8c"
  fi

  # --- Đường dẫn infobase ---
  case "$IB_PATH" in /*) IB="$IB_PATH" ;; *) IB="$ROOT/$IB_PATH" ;; esac

  AUTH=()
  if [ -n "$IB_USER" ]; then AUTH=(/N "$IB_USER" /P "$IB_PWD"); fi
  COMMON=(/DisableStartupDialogs /DisableStartupMessages /L "$UI_LANG")
  return 0
}

# Chạy Designer ở chế độ batch rồi kiểm tra kết quả.
# Cách dùng: run_designer <tên-bước> <lệnh Designer...>
run_designer() {
  local step="$1"; shift
  local log="$LOGDIR/$step.log" res="$LOGDIR/$step.result"
  rm -f "$log" "$res"
  echo
  echo "=== [$step] đang chạy Designer ..."
  "$V8_PATH" DESIGNER /F "$IB" "${AUTH[@]}" "${COMMON[@]}" /Out "$log" /DumpResult "$res" "$@"
  [ -f "$log" ] && cat "$log"
  if [ ! -f "$res" ] || grep -q 1 "$res"; then
    echo "=== [$step] LỖI. Xem chi tiết: logs/$step.log"
    return 1
  fi
  echo "=== [$step] OK"
}

require_src() {
  if [ ! -f "$SRC/Configuration.xml" ]; then
    echo "[LỖI] src/cf chưa có cấu hình. Chạy dump.sh trước."
    return 1
  fi
}
