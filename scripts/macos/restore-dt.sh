#!/usr/bin/env bash
# Tạo infobase (nếu chưa có) và nạp file .dt vào.
# Cách dùng: restore-dt.sh [đường-dẫn-file.dt]   (không truyền: lấy file .dt đầu tiên trong dt/)
source "$(dirname "$0")/_env.sh"; load_env || exit 1
DT="${1:-}"
if [ -z "$DT" ]; then DT="$(ls "$ROOT"/dt/*.dt 2>/dev/null | head -n 1)"; fi
if [ -z "$DT" ] || [ ! -f "$DT" ]; then
  echo "[LỖI] Không tìm thấy file .dt. Chép file .dt vào thư mục dt/ hoặc truyền đường dẫn."; exit 1
fi
if [ ! -f "$IB/1Cv8.1CD" ]; then
  echo "Tạo infobase mới tại $IB ..."
  "$V8_PATH" CREATEINFOBASE "File=\"$IB\"" /Out "$LOGDIR/create.log"
  if [ ! -f "$IB/1Cv8.1CD" ]; then cat "$LOGDIR/create.log" 2>/dev/null; echo "[LỖI] Không tạo được infobase."; exit 1; fi
fi
read -r -p "CẢNH BÁO: dữ liệu trong $IB sẽ bị thay bằng $DT. Tiếp tục? [y/N] " ans
case "$ans" in y|Y) ;; *) exit 1 ;; esac
run_designer restore /RestoreIB "$DT"
