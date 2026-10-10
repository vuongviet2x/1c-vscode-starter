#!/usr/bin/env bash
# Tạo infobase trống (không có cấu hình) — dùng cho lớp MIS tự xây dựng hệ thống.
source "$(dirname "$0")/_env.sh"; load_env || exit 1
if [ -f "$IB/1Cv8.1CD" ]; then echo "[LỖI] Đã có infobase tại $IB. Xóa thư mục ib nếu muốn tạo lại."; exit 1; fi
"$V8_PATH" CREATEINFOBASE "File=\"$IB\"" /Out "$LOGDIR/create.log"
cat "$LOGDIR/create.log" 2>/dev/null
[ -f "$IB/1Cv8.1CD" ] || { echo "[LỖI] Không tạo được infobase."; exit 1; }
echo "[OK] Đã tạo infobase trống tại $IB. Chạy dump.sh để xuất cấu hình ra src/cf."
