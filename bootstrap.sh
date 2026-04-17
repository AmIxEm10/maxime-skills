#!/usr/bin/env bash
# bootstrap.sh — installe les skills dans un Codespace et push sur GitHub
#
# Usage : ./bootstrap.sh
#
# Ce script est conçu pour tourner dans GitHub Codespaces.
# Il suppose que :
#   1. Tu as créé un repo GitHub vide (ex: AmIxEm10/maxime-skills)
#   2. Tu as ouvert un Codespace dessus
#   3. Tu as drag-and-droppé ce ZIP dans le Codespace puis dézippé
#   4. Tu lances ce script depuis le dossier extrait

set -euo pipefail

echo "🚀 Bootstrap maxime-skills"
echo ""

# Vérifier qu'on est bien dans un dossier avec les skills
if [ ! -f "INDEX.md" ] || [ ! -d "fitness-coach" ]; then
  echo "❌ Ce script doit être lancé depuis la racine du dossier maxime-skills"
  echo "   (celui qui contient INDEX.md, README.md et tous les dossiers de skills)"
  exit 1
fi

# Vérifier qu'on est dans un repo git
if [ ! -d ".git" ]; then
  echo "📦 Pas de .git/ détecté — initialisation..."
  git init -q -b main
fi

# Nom + email git (requis pour commit)
if [ -z "$(git config user.email)" ]; then
  git config user.email "maxime@github.com"
  git config user.name "Maxime"
fi

# Compter les skills
skill_count=$(find . -maxdepth 2 -name "SKILL.md" | wc -l | tr -d ' ')
echo "✅ $skill_count skills détectés"
echo ""

# Stage + commit
git add .
if git diff --cached --quiet; then
  echo "ℹ️  Aucun changement à committer"
else
  echo "📝 Création du commit initial..."
  git commit -q -m "feat: initial release — $skill_count skills for Claude Code

Includes:
- Personal skills (fitness-coach, rapport, portfolio-builder, chrome-ext, game-design, ckm*)
- Official Anthropic skills (docx, pdf, pptx, xlsx, frontend-design, skill-creator, etc.)
- Technical skills (AI/ML, languages, frameworks, DevOps, security, etc.)

Ready to use with Claude Code (local + cloud) and Claude Desktop."
fi

# Vérifier si un remote est configuré
if git remote get-url origin >/dev/null 2>&1; then
  REMOTE_URL=$(git remote get-url origin)
  echo "🔗 Remote détecté : $REMOTE_URL"
  echo ""
  echo "📤 Push vers GitHub..."
  git push -u origin main
  echo ""
  echo "🎉 Terminé !"
  # Extraire le nom du repo
  REPO_NAME=$(echo "$REMOTE_URL" | sed -E 's|.*github.com[:/]([^.]+)(\.git)?|\1|')
  echo "   Repo : https://github.com/$REPO_NAME"
else
  echo "⚠️  Aucun remote git configuré."
  echo ""
  echo "Dans Codespaces c'est normalement déjà fait. Si ce n'est pas le cas :"
  echo ""
  echo "   git remote add origin https://github.com/AmIxEm10/NOM-DU-REPO.git"
  echo "   git push -u origin main"
fi

echo ""
echo "──────────────────────────────────────────────"
echo "Prochaine étape — utiliser les skills :"
echo ""
echo "• Claude Code local    → ./install.sh"
echo "• Claude Code cloud    → voir .claude/settings.json (hook SessionStart)"
echo "• Claude Desktop       → ./install.sh"
echo "──────────────────────────────────────────────"
