#!/usr/bin/env bash
# Xuất cấu hình từ infobase ra src/cf (sau khi sửa trong Designer).
source "$(dirname "$0")/_env.sh"; load_env || exit 1
if [ -n "$PLATFORM_MISMATCH" ] && [ "$ALLOW_PLATFORM_MISMATCH" != "1" ]; then
  echo "[DỪNG] Không dump khi platform khác phiên bản chung của nhóm."
  echo "       Đổi V8_VERSION / V8_PATH sang bản $TEAM_V8.x, hoặc cả nhóm thống nhất đổi file .1c-platform."
  echo "       Biết chắc mình làm gì: thêm ALLOW_PLATFORM_MISMATCH=1 vào 1c.env."
  exit 1
fi
UPD=()
[ -f "$SRC/ConfigDumpInfo.xml" ] && UPD=(-update -force)
run_designer dump /DumpConfigToFiles "$SRC" -Format Hierarchical "${UPD[@]}"
