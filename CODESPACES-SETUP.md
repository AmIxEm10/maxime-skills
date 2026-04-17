# 🚀 Setup via GitHub Codespaces (sans git local)

Tu n'as pas git installé sur ton PC ? Pas de souci. GitHub te donne un **PC Linux virtuel gratuit** dans le navigateur avec tout déjà installé. Voici le workflow complet, **4 étapes**, **5 minutes**.

## 1️⃣ Créer un repo GitHub vide

Va sur 👉 **https://github.com/new**

- **Repository name** : `maxime-skills`
- **Visibility** : Public (ou Private si tu préfères)
- ⚠️ **NE COCHE RIEN** (pas de README, pas de .gitignore, pas de licence) — on veut un repo **100% vide**
- Clique **Create repository**

## 2️⃣ Ouvrir un Codespace

Sur la page du nouveau repo (qui sera vide) :

1. Clique le bouton vert **`< > Code`** en haut à droite
2. Onglet **`Codespaces`**
3. Clique **`Create codespace on main`**

VSCode s'ouvre dans ton navigateur après ~30 secondes. Tu es dans un PC Linux complet.

## 3️⃣ Uploader le ZIP

Dans le Codespace :

1. Sur le panneau gauche (l'Explorer de fichiers), **drag-and-drop** `maxime-skills.zip` depuis ton PC
2. Attends que l'upload finisse (tu verras le fichier apparaître dans la liste)

## 4️⃣ Lancer le bootstrap (1 commande)

Ouvre le terminal dans Codespaces (`Ctrl + ù` ou menu `Terminal > New Terminal`) et colle ça :

```bash
unzip -q maxime-skills.zip && cd maxime-skills && chmod +x bootstrap.sh && ./bootstrap.sh
```

Le script va :
- ✅ Dézipper les 143 skills
- ✅ Détecter que tu es dans un Codespace (remote git déjà configuré automatiquement)
- ✅ Créer le commit initial
- ✅ Push sur ton repo GitHub
- ✅ Afficher l'URL du repo une fois fini

## 🎯 Une fois le push terminé

Ton repo https://github.com/AmIxEm10/maxime-skills contient les 143 skills. Tu peux :

### A. L'utiliser directement dans Claude Code cloud (`claude.com/code`)

Copie `.claude/settings.json` dans tes autres projets. Le hook `SessionStart` clone automatiquement le repo dans chaque session cloud.

### B. L'installer en local (si tu installes git/Claude Code plus tard)

```bash
git clone https://github.com/AmIxEm10/maxime-skills.git ~/maxime-skills
cd ~/maxime-skills && ./install.sh
```

### C. L'installer via plugin

```bash
# Dans Claude Code
/plugin marketplace add AmIxEm10/maxime-skills
/plugin install maxime-skills
```

## 💡 Bonus : réutiliser le Codespace

- Tu peux **fermer l'onglet** du Codespace une fois le push fait — il s'arrête tout seul après 30 min d'inactivité
- Pour y retourner : onglet `Codespaces` du repo, il est gardé pendant 30 jours
- Gratuit jusqu'à **60h/mois** (largement suffisant pour ce genre d'op)
- Pour le supprimer : `github.com/codespaces` → bouton `...` → `Delete`

## 🆘 Si ça bloque

**Le drag-and-drop ne marche pas**
→ Clic droit dans l'explorer VSCode → `Upload...` et sélectionne le ZIP

**`unzip: command not found`**
→ Rare, mais fais : `sudo apt-get install -y unzip` puis relance la commande

**`Permission denied` sur bootstrap.sh**
→ Déjà géré par `chmod +x` dans la commande. Si ça persiste : `bash bootstrap.sh` directement

**Le push échoue avec erreur d'authentification**
→ Dans Codespaces c'est déjà configuré normalement. Sinon : `gh auth login` puis relance `./bootstrap.sh`

---

⏱️ **Temps total estimé** : 5 minutes (dont 3 pour l'upload du ZIP selon ta connexion)
