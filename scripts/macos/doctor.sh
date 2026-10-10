#!/usr/bin/env bash
# Kiểm tra môi trường làm việc: platform, infobase, mã nguồn, skill, công cụ.
HERE="$(dirname "$0")"
ROOT="$(cd "$HERE/../.." && pwd)"
echo "==== Kiểm tra môi trường 1C + VS Code ===="
if [ ! -f "$ROOT/1c.env" ]; then
  cp "$ROOT/1c.env.example" "$ROOT/1c.env"
  echo "[MỚI]   Đã tạo 1c.env từ 1c.env.example. Mở file này và kiểm tra lại."
fi
source "$HERE/_env.sh"
if load_env; then
  echo "[OK]   Platform: $V8_DETECTED  ($V8_PATH)"
  [ -n "$TEAM_V8" ] && [ -z "$PLATFORM_MISMATCH" ] && echo "[OK]   Đúng phiên bản chung của nhóm: $TEAM_V8.x"
  [ -x "$V8C_PATH" ] && echo "[OK]   Thin client: $V8C_PATH" || echo "[CẢNH BÁO] Không thấy 1cv8c — run.sh sẽ dùng 1cv8"
  [ -f "$IB/1Cv8.1CD" ] && echo "[OK]   Infobase: $IB" || echo "[THIẾU] Chưa có infobase tại $IB — chạy restore-dt.sh"
  [ -f "$SRC/Configuration.xml" ] && echo "[OK]   Mã nguồn: src/cf" || echo "[THIẾU] src/cf trống — chạy dump.sh"
fi
SK="$(ls -d "$ROOT"/.claude/skills/*/ 2>/dev/null | while read -r d; do [ -f "$d/SKILL.md" ] && basename "$d"; done | head -n 1)"
[ -n "$SK" ] && echo "[OK]   Skill đã cài: $SK" || echo "[THIẾU] Chưa cài skill — chạy install-skill.sh <file 1c-dev-mentor-student-claude-gpt.zip>"
command -v git >/dev/null && echo "[OK]   Git" || echo "[THIẾU] Git — chạy: xcode-select --install"
command -v code >/dev/null && echo "[OK]   VS Code (lệnh code)" || echo "[CẢNH BÁO] Không thấy lệnh 'code' — trong VS Code: Cmd+Shift+P → Shell Command: Install 'code' command in PATH"
command -v claude >/dev/null && echo "[OK]   Claude Code CLI" || echo "[TÙY CHỌN] Chưa có Claude Code CLI — extension VS Code vẫn dùng được"
echo "=========================================="
