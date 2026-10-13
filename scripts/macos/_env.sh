#!/usr/bin/env bash
# Đọc 1c.env và chuẩn bị biến + hàm dùng chung. Các script khác: source "$(dirname "$0")/_env.sh"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
SRC="$ROOT/src/cf"
LOGDIR="$ROOT/logs"
mkdir -p "$LOGDIR"

# Liệt kê platform đã cài: mỗi dòng "phiên-bản|đường-dẫn-1cv8"
list_platforms() {
  local p v
  for p in /Applications/1cv8*/*/1cv8.app/Contents/MacOS/1cv8 /Applications/1cv8*/*/1cv8t.app/Contents/MacOS/1cv8t \
           /opt/1cv8*/*/*/1cv8 /opt/1cv8*/*/*/1cv8t; do
    [ -x "$p" ] || continue
    v="$(printf '%s' "$p" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)"
    [ -n "$v" ] && echo "$v|$p"
  done
}

load_env() {
  if [ ! -f "$ROOT/1c.env" ]; then
    echo "[LỖI] Chưa có file 1c.env. Chạy scripts/macos/doctor.sh (tự tạo) hoặc: cp 1c.env.example 1c.env"
    return 1
  fi
  V8_VERSION=""; V8_PATH=""; IB_PATH=""; IB_USER=""; IB_PWD=""; UI_LANG=""; ALLOW_PLATFORM_MISMATCH=""
  while IFS='=' read -r key val || [ -n "$key" ]; do
    key="$(printf '%s' "$key" | tr -d '[:space:]')"
    case "$key" in ''|\#*) continue ;; esac
    val="${val%$'\r'}"
    printf -v "$key" '%s' "$val"
  done < "$ROOT/1c.env"
  UI_LANG="${UI_LANG:-en}"
  IB_PATH="${IB_PATH:-ib}"

  # --- Tìm 1cv8 (Designer) ---
  # V8_PATH điền sẵn -> dùng luôn. Không thì tự chọn bản MỚI NHẤT khớp V8_VERSION
  # (V8_VERSION trống = mọi bản; 8.3.25 = mọi bản 8.3.25.x; 8.3.25.1445 = đúng bản đó).
  if [ -z "$V8_PATH" ]; then
    V8_PATH="$(list_platforms | while IFS='|' read -r v p; do
        if [ -n "$V8_VERSION" ]; then case "$v." in "$V8_VERSION".*) ;; *) continue ;; esac; fi
        echo "$v|$p"; done | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n | tail -n 1 | cut -d'|' -f2)"
  fi
  if [ ! -x "$V8_PATH" ]; then
    if [ -z "$V8_VERSION" ]; then echo "[LỖI] Không tìm thấy platform 1C:Enterprise nào trên máy."
    else echo "[LỖI] Không tìm thấy platform khớp V8_VERSION=$V8_VERSION."; fi
    echo "      Các bản platform tìm thấy:"
    list_platforms | sort -t. -k1,1n -k2,2n -k3,3n -k4,4n | while IFS='|' read -r v p; do echo "        $v   ->  $p"; done
    echo "      Sửa V8_VERSION trong 1c.env (để trống = tự chọn bản mới nhất), hoặc điền V8_PATH."
    return 1
  fi
  V8C_PATH="$(dirname "$V8_PATH")/1cv8c"
  case "$(basename "$V8_PATH")" in 1cv8t) V8C_PATH="$(dirname "$V8_PATH")/1cv8ct" ;; esac
  if [ ! -x "$V8C_PATH" ]; then
    # macOS: 1cv8c.app nằm cạnh 1cv8.app
    V8C_PATH="$(cd "$(dirname "$V8_PATH")/../../.." 2>/dev/null && pwd)/1cv8c.app/Contents/MacOS/1cv8c"
  fi

  # --- So phiên bản platform với phiên bản chung của nhóm (.1c-platform) ---
  V8_DETECTED="$(printf '%s' "$V8_PATH" | grep -oE '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+' | head -n 1)"
  TEAM_V8=""; PLATFORM_MISMATCH=""
  [ -f "$ROOT/.1c-platform" ] && TEAM_V8="$(head -n 1 "$ROOT/.1c-platform" | tr -d '[:space:]')"
  if [ -n "$TEAM_V8" ]; then
    case "$V8_DETECTED." in "$TEAM_V8".*) ;; *)
      PLATFORM_MISMATCH=1
      echo "[CẢNH BÁO] Platform của bạn là ${V8_DETECTED:-?}, nhóm đang dùng $TEAM_V8.x (file .1c-platform)."
      echo "           dump bằng bản khác có thể làm cả nhóm không nạp được src/cf. Xem docs/06-lam-viec-nhom.md" ;;
    esac
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
  if [ ! -f "$IB/1Cv8.1CD" ]; then
    echo "[LỖI] Chưa có infobase tại: $IB"
    echo "      Làm bước tạo infobase trước: restore-dt.sh (có file .dt) hoặc new-ib.sh (cấu hình trống)."
    return 1
  fi
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
