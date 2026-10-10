#!/usr/bin/env bash
# Xuất cấu hình từ infobase ra src/cf (sau khi sửa trong Designer).
source "$(dirname "$0")/_env.sh"; load_env || exit 1
UPD=()
[ -f "$SRC/ConfigDumpInfo.xml" ] && UPD=(-update -force)
run_designer dump /DumpConfigToFiles "$SRC" -Format Hierarchical "${UPD[@]}"
