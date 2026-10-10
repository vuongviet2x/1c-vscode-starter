#!/usr/bin/env bash
# Nạp code từ src/cf vào cấu hình và kiểm tra cú pháp module. KHÔNG cập nhật database.
source "$(dirname "$0")/_env.sh"; load_env || exit 1; require_src || exit 1
run_designer backup /DumpCfg "$LOGDIR/backup-before-load.cf" || exit 1
run_designer load /LoadConfigFromFiles "$SRC" -Format Hierarchical -updateConfigDumpInfo || exit 1
run_designer check /CheckModules -ThinClient -WebClient -Server -ExternalConnection
