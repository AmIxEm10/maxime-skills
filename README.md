# 🧠 maxime-skills

Collection complète de **143 skills** pour Claude Code et Claude Desktop — incluant mes skills personnels, les skills officiels Anthropic, et un gros pack de skills techniques (IA/ML, langages, frameworks, DevOps, sécurité…).

> 📖 **Liste complète catégorisée → [`INDEX.md`](./INDEX.md)**

## 🚀 Installation rapide

### Option 1 — Local (Claude Code CLI + Desktop)

```bash
git clone https://github.com/AmIxEm10/maxime-skills.git ~/maxime-skills
cd ~/maxime-skills
./install.sh              # crée des symlinks dans ~/.claude/skills/
# ou
./install.sh --copy       # copie physique (indépendant du repo)
```

Les skills sont immédiatement disponibles dans Claude Code et Claude Desktop. Un `/reload-plugins` dans une session active suffit à les recharger.

### Option 2 — Claude Code cloud (`claude.com/code`)

Le sandbox cloud ne voit pas ton `~/.claude/` local. Utilise le hook `SessionStart` fourni pour auto-cloner le repo au démarrage de chaque session :

```bash
# Dans chacun de tes projets où tu veux tes skills en cloud
cp /chemin/vers/maxime-skills/.claude/settings.json .claude/settings.json
git add .claude/settings.json && git commit -m "chore: add maxime-skills hook"
```

À la prochaine session cloud sur ce repo, tous les skills sont cloné automatiquement dans le sandbox.

### Option 3 — Plugin Claude Code

```bash
# Dans Claude Code
/plugin marketplace add AmIxEm10/maxime-skills
/plugin install maxime-skills
```

## 📂 Structure

```
maxime-skills/
├── README.md                   ← ce fichier
├── INDEX.md                    ← catalogue complet catégorisé
├── install.sh                  ← script d'installation locale
├── .claude-plugin/
│   └── plugin.json             ← manifeste du plugin Claude Code
├── .claude/
│   └── settings.json           ← exemple de hook SessionStart pour le cloud
├── fitness-coach/              ← chaque dossier = 1 skill
│   ├── SKILL.md                (obligatoire, contient frontmatter + instructions)
│   ├── references/             (docs chargées à la demande)
│   ├── scripts/                (scripts exécutables)
│   └── assets/                 (templates, images, fonts)
├── rapport/
├── portfolio-builder/
└── ... (140 autres)
```

## 🎯 Top 12 — mes skills les plus utiles

| Skill | Usage typique |
|---|---|
| **fitness-coach** | Séances muscu, programmes, FORGE, calcul 1RM |
| **rapport** | Rapports SAÉ, TP, livrables BUT/IUT |
| **portfolio-builder** | Composants & contenus portfolio BUT3 / soutenance |
| **chrome-ext** | Extensions Chrome MV3 (SwissKit & co.) |
| **game-design** | Mécaniques de jeu, feel, équilibrage (Oni Burst, ASHENBLADE) |
| **ckmdesign** | Identité de marque, logos, bannières, icônes |
| **ckmslides** | Présentations HTML stratégiques avec Chart.js |
| **ui-ux-pro-max** | 50+ styles, 161 palettes, 57 pairings de polices |
| **frontend-design** | UI production-grade anti-"AI slop" |
| **react-specialist** | React 19, hooks, concurrent features |
| **python-engineer** | Python 3.12+, async, pydantic, typing |
| **skill-creator** | Créer/modifier/évaluer d'autres skills |

## 🔄 Mise à jour

Si tu as installé en mode **symlink** (défaut) :

```bash
cd ~/maxime-skills && git pull
# Les skills sont automatiquement à jour dans ~/.claude/skills/
```

Si tu as installé en mode **copy** :

```bash
cd ~/maxime-skills && git pull && ./install.sh --force
```

## 🛠️ Ajouter un skill perso

1. Crée un dossier à la racine : `mkdir mon-nouveau-skill`
2. Ajoute `mon-nouveau-skill/SKILL.md` avec le frontmatter YAML requis :
   ```yaml
   ---
   name: mon-nouveau-skill
   description: Quand et comment Claude doit utiliser ce skill. Sois PUSHY — décris bien les triggers pour éviter l'undertriggering.
   ---
   ```
3. Rédige les instructions en Markdown en-dessous
4. `git add . && git commit && git push`
5. `./install.sh` pour le lier localement

Besoin d'aide ? Le skill `skill-creator` est fait pour ça.

## 📜 Licences

- **Skills personnels** (fitness-coach, rapport, portfolio-builder, chrome-ext, game-design, ckm*) : MIT, propriété de l'auteur
- **Skills officiels Anthropic** (docx, pdf, pptx, xlsx, frontend-design, file-reading, pdf-reading, skill-creator, mcp-builder, canvas-design, algorithmic-art, brand-guidelines, theme-factory, slack-gif-creator, web-artifacts-builder, doc-coauthoring, internal-comms, product-self-knowledge) : voir [github.com/anthropics/skills](https://github.com/anthropics/skills) pour les licences originales
- **Skills techniques tiers** (les ~120 autres) : skills agents génériques, utilise-les à ta discrétion

## 🙋 Troubleshooting

**Les skills ne se déclenchent pas** → vérifie que le dossier apparaît bien dans `~/.claude/skills/<nom>/SKILL.md` (pas de sous-dossier intermédiaire), et que le frontmatter YAML est valide.

**Conflit de noms avec d'autres skills** → `./install.sh` sans `--force` les ignore par défaut.

**Trop de skills = ralentissement** → supprime les symlinks dont tu ne te sers pas :
```bash
cd ~/.claude/skills && rm nom-du-skill-inutile
```

---

Construit avec ❤️ par Maxime • Powered by Claude
