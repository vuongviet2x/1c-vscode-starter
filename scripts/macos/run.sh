#!/usr/bin/env bash
# Mở infobase ở chế độ 1C:Enterprise (thin client).
source "$(dirname "$0")/_env.sh"; load_env || exit 1
CLIENT="$V8C_PATH"; [ -x "$CLIENT" ] || CLIENT="$V8_PATH"
nohup "$CLIENT" ENTERPRISE /F "$IB" "${AUTH[@]}" /L "$UI_LANG" >/dev/null 2>&1 &
echo "Đã mở 1C:Enterprise."
