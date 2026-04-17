#!/usr/bin/env bash
# install.sh — installe maxime-skills dans ~/.claude/skills/
# Usage : ./install.sh [--symlink|--copy] [--force]
#
# --symlink (défaut) : crée des liens symboliques vers ce repo (mises à jour via git pull automatiques)
# --copy             : copie les fichiers (indépendant du repo)
# --force            : écrase les skills existants sans demander

set -euo pipefail

MODE="symlink"
FORCE=false

for arg in "$@"; do
  case "$arg" in
    --copy) MODE="copy" ;;
    --symlink) MODE="symlink" ;;
    --force) FORCE=true ;;
    -h|--help)
      grep '^#' "$0" | head -10 | sed 's/^# \?//'
      exit 0
      ;;
  esac
done

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="$HOME/.claude/skills"

mkdir -p "$TARGET_DIR"

echo "🔧 Installation de maxime-skills"
echo "   Mode    : $MODE"
echo "   Source  : $REPO_DIR"
echo "   Cible   : $TARGET_DIR"
echo ""

count=0
skipped=0
for skill_dir in "$REPO_DIR"/*/; do
  skill_name=$(basename "$skill_dir")
  # Ignorer les dossiers non-skills
  case "$skill_name" in
    .claude|.claude-plugin|.git|scripts|node_modules) continue ;;
  esac
  # Vérifier qu'il y a bien un SKILL.md
  [ -f "$skill_dir/SKILL.md" ] || continue

  dest="$TARGET_DIR/$skill_name"

  if [ -e "$dest" ] && [ "$FORCE" = false ]; then
    echo "⏭️  $skill_name (déjà présent, --force pour écraser)"
    skipped=$((skipped+1))
    continue
  fi

  rm -rf "$dest"
  if [ "$MODE" = "symlink" ]; then
    ln -s "$skill_dir" "$dest"
  else
    cp -r "$skill_dir" "$dest"
  fi
  count=$((count+1))
done

echo ""
echo "✅ $count skills installés, $skipped ignorés"
echo ""
echo "Redémarre Claude Code pour prendre en compte les nouveaux skills."
echo "Dans une session active, tape : /reload-plugins"
