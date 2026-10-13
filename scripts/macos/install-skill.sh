#!/usr/bin/env bash
# Cài skill từ file ZIP giảng viên gửi vào <dự-án>/.claude/skills/<tên-skill>/
# Cách dùng: install-skill.sh ~/Downloads/1c-dev-mentor-student-claude-gpt.zip
set -e
ZIP="${1:-}"
[ -n "$ZIP" ] && [ -f "$ZIP" ] || { echo "Cách dùng: install-skill.sh <đường-dẫn-file-zip>"; exit 1; }
case "$(basename "$ZIP" | tr '[:upper:]' '[:lower:]')" in *gemini*) echo "[LỖI] Đây là bản skill cho Gemini. Trong VS Code hãy dùng file 1c-dev-mentor-student-claude-gpt.zip"; exit 1 ;; esac
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
TMP="$(mktemp -d)"
unzip -q "$ZIP" -d "$TMP"
SKILL_MD="$(find "$TMP" -name SKILL.md -not -path '*/__MACOSX/*' | head -n 1)"
[ -n "$SKILL_MD" ] || { echo "[LỖI] File ZIP không chứa SKILL.md."; rm -rf "$TMP"; exit 1; }
NAME="$(sed -n 's/^name:[[:space:]]*"\{0,1\}\([^"]*\)"\{0,1\}[[:space:]]*$/\1/p' "$SKILL_MD" | head -n 1)"
[ -n "$NAME" ] || NAME="$(basename "$(dirname "$SKILL_MD")")"
for SD in "$ROOT/.claude/skills" "$ROOT/.agents/skills"; do   # Claude Code + Antigravity/Gemini
  mkdir -p "$SD"; rm -rf "$SD/$NAME"; cp -R "$(dirname "$SKILL_MD")" "$SD/$NAME"
done
DEST="$ROOT/.claude/skills/$NAME"
rm -rf "$TMP"
VER="$(grep -o 'Phiên bản [0-9.]*[-a-z]*' "$DEST/SKILL.md" | head -n 1)"
echo "[OK] Đã cài skill '$NAME' ($VER) vào .claude/skills/$NAME và .agents/skills/$NAME"
echo "     Claude Code: mở lại panel (hoặc gõ /reload-skills). Antigravity: mở lại cửa sổ agent."
