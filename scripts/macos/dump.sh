#!/usr/bin/env bash
# Xuất cấu hình từ infobase ra src/cf (sau khi sửa trong Designer).
source "$(dirname "$0")/_env.sh"; load_env || exit 1
if [ -n "$PLATFORM_MISMATCH" ] && [ "$ALLOW_PLATFORM_MISMATCH" != "1" ]; then
  echo "[DỪNG] Không dump khi platform khác phiên bản chung của nhóm ($TEAM_V8.x)."
  echo "       Đặt V8_VERSION=$TEAM_V8 trong 1c.env, hoặc cả nhóm thống nhất sửa file .1c-platform."
  echo "       Biết chắc mình làm gì: thêm ALLOW_PLATFORM_MISMATCH=1 vào 1c.env."
  exit 1
fi
UPD=()
[ -f "$SRC/ConfigDumpInfo.xml" ] && UPD=(-update -force)
run_designer dump /DumpConfigToFiles "$SRC" -Format Hierarchical "${UPD[@]}" || exit 1

# Lần dump đầu tiên: ghi phiên bản platform vào .1c-platform để cả nhóm dùng chung
if [ ! -f "$ROOT/.1c-platform" ] && [ -n "$V8_DETECTED" ]; then
  TEAM_NEW="$(printf '%s' "$V8_DETECTED" | cut -d. -f1-3)"
  printf '%s' "$TEAM_NEW" > "$ROOT/.1c-platform"
  echo "[MỚI] Đã ghi phiên bản platform $TEAM_NEW vào file .1c-platform. Commit file này để cả nhóm dùng chung bản."
fi
