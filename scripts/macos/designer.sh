#!/usr/bin/env bash
# Mở Designer (giao diện) cho infobase của dự án.
source "$(dirname "$0")/_env.sh"; load_env || exit 1
nohup "$V8_PATH" DESIGNER /F "$IB" "${AUTH[@]}" /L "$UI_LANG" >/dev/null 2>&1 &
echo "Đã mở Designer."
