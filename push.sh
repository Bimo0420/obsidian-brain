#!/bin/bash
# push.sh — Синхронизирует шаблонные файлы из wiki в GitHub (vault/)
# Работает во временном клоне, не трогает рабочую директорию wiki.
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_URL="$(cd "$SCRIPT_DIR" && git remote get-url origin)"
TMP="$SCRIPT_DIR/_deploy_tmp"
MSG="${1:-Update vault template from wiki}"

# Очистка при выходе
cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

# 1. Клонируем репо во временную папку
rm -rf "$TMP"
echo "Cloning repo..."
git clone --depth 1 "$REPO_URL" "$TMP"

# 2. Очищаем vault/ для полной синхронизации
rm -rf "$TMP/vault/.obsidian" "$TMP/vault/hooks" "$TMP/vault/scripts"

# 3. Копируем шаблонные файлы из wiki в vault/
echo "Syncing template files..."

# .obsidian (плагины, темы, конфиги)
cp -r "$SCRIPT_DIR/.obsidian" "$TMP/vault/.obsidian"
# Удаляем машинно-специфичные и секретные файлы
rm -f "$TMP/vault/.obsidian/workspace.json"
rm -f "$TMP/vault/.obsidian/workspace-mobile.json"
find "$TMP/vault/.obsidian/plugins" -name "data.json" -delete 2>/dev/null
rm -rf "$TMP/vault/.obsidian/plugins/mcp-tools/bin"

# Хуки и скрипты
cp -r "$SCRIPT_DIR/hooks" "$TMP/vault/hooks"
cp -r "$SCRIPT_DIR/scripts" "$TMP/vault/scripts"
# Удаляем рантайм-артефакты скриптов
rm -f "$TMP/vault/scripts/state.json"
rm -f "$TMP/vault/scripts/last-flush.json"
rm -f "$TMP/vault/scripts/"*.log
rm -f "$TMP/vault/scripts/session-flush-"*
rm -f "$TMP/vault/scripts/flush-context-"*
rm -rf "$TMP/vault/scripts/__pycache__"

# Корневые файлы проекта
for f in AGENTS.md README.md pyproject.toml uv.lock compile.cmd process.cmd .gitignore; do
  [ -f "$SCRIPT_DIR/$f" ] && cp "$SCRIPT_DIR/$f" "$TMP/vault/$f"
done

# Структура контентных папок (пустые .gitkeep)
for d in daily Excalidraw knowledge/concepts knowledge/connections knowledge/qa processed raw; do
  mkdir -p "$TMP/vault/$d"
  touch "$TMP/vault/$d/.gitkeep"
done

# Стартовые файлы knowledge
if [ ! -f "$TMP/vault/knowledge/index.md" ]; then
  printf "# Knowledge Base Index\n\n| Article | Summary | Compiled From | Updated |\n|---------|---------|---------------|---------|\n" \
    > "$TMP/vault/knowledge/index.md"
fi
if [ ! -f "$TMP/vault/knowledge/log.md" ]; then
  printf "# Knowledge Base Processing Log\n" > "$TMP/vault/knowledge/log.md"
fi

# 4. Коммит и пуш
cd "$TMP"
git add -A
if git diff --cached --quiet; then
  echo "No changes to push — vault is up to date."
else
  git commit -m "$MSG"
  git push
  echo "Pushed successfully."
fi
