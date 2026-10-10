#!/usr/bin/env bash
# Nạp code từ src/cf vào cấu hình VÀ cập nhật database (giống F7 trong Designer).
# Đóng Designer và các phiên 1C:Enterprise đang mở infobase này trước khi chạy.
source "$(dirname "$0")/_env.sh"; load_env || exit 1; require_src || exit 1
run_designer backup /DumpCfg "$LOGDIR/backup-before-load.cf" || exit 1
run_designer load /LoadConfigFromFiles "$SRC" -Format Hierarchical -updateConfigDumpInfo || exit 1
run_designer update /UpdateDBCfg
