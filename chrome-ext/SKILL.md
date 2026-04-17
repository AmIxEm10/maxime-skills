---
name: chrome-ext
description: "Guide complet de développement d'extensions Chrome (Manifest V3). Utilise ce skill dès que l'utilisateur veut créer, modifier, débugger ou publier une extension Chrome. Déclencheurs : 'extension Chrome', 'extension navigateur', 'manifest', 'manifest V3', 'MV3', 'popup', 'content script', 'service worker', 'background script', 'chrome.tabs', 'chrome.storage', 'chrome.runtime', 'Chrome Web Store', 'browser extension', 'SwissKit', ou toute mention de développement d'addon navigateur. Utilise-le aussi quand l'utilisateur demande d'ajouter un module à une extension existante, de résoudre un bug d'extension, ou de porter une extension V2 vers V3."
---

# Chrome Extension Developer

**Purpose:** Guide complet pour créer des extensions Chrome avec Manifest V3 — de l'idée à la publication sur le Chrome Web Store. Couvre l'architecture, les APIs Chrome, le messaging, le stockage, les permissions, le debugging et la publication.

---

## Workflow principal

### Quand l'utilisateur veut créer une extension

1. **Clarifier le besoin** : que fait l'extension ? Sur quels sites ? Quelles interactions utilisateur ?
2. **Identifier les composants nécessaires** : popup ? content script ? service worker ? options page ?
3. **Consulter** `references/architecture.md` pour le design de l'architecture
4. **Consulter** `references/apis-reference.md` pour les APIs et permissions nécessaires
5. **Générer le code** : manifest.json d'abord, puis chaque composant
6. **Fournir les instructions de test** : chargement en mode développeur, debugging

### Quand l'utilisateur veut modifier/débugger une extension existante

1. **Lire les fichiers** uploadés (manifest.json en priorité pour comprendre la structure)
2. **Identifier le problème** : permissions, messaging, lifecycle du service worker, CSP
3. **Proposer le fix** avec explication

### Quand l'utilisateur veut publier

1. **Checklist de publication** : icons, description, screenshots, privacy policy
2. **Packaging** : commande zip
3. **Conseils Chrome Web Store** : review process, best practices

---

## Architecture Manifest V3 — Vue d'ensemble

```
Extension Chrome (Manifest V3)
│
├── manifest.json            ← Obligatoire. Identité + config + permissions
│
├── Service Worker           ← background.js — écoute les événements Chrome
│   (background)               Pas de DOM, pas persistent, s'éteint quand inactif
│   │                          Accès : toutes les APIs Chrome déclarées
│   │
│   ├── chrome.runtime       ← Messaging, lifecycle, installation
│   ├── chrome.storage       ← Stockage persistant (sync/local)
│   ├── chrome.tabs          ← Gestion des onglets
│   ├── chrome.alarms        ← Tâches planifiées (remplace setInterval)
│   └── chrome.contextMenus  ← Menus clic-droit
│
├── Content Scripts          ← Injectés dans les pages web
│   (content.js)               Accès au DOM de la page
│                              Contexte JS isolé de la page
│                              Communication avec le SW via messaging
│
├── Popup                    ← UI au clic sur l'icône
│   ├── popup.html             Mini page web (HTML/CSS/JS)
│   └── popup.js               Se ferme = script unmount
│
├── Options Page             ← Page de configuration
│   ├── options.html           Accessible via chrome://extensions
│   └── options.js
│
├── Side Panel (optionnel)   ← Panneau latéral persistant
│
└── Icons                    ← 16×16, 48×48, 128×128 px
```

**Règle critique MV3 :** Le service worker n'est PAS persistent. Il s'éteint après ~30s d'inactivité. Ne jamais stocker d'état dans des variables globales → utiliser `chrome.storage`.

---

## Manifest.json — Template de base

```json
{
  "manifest_version": 3,
  "name": "Mon Extension",
  "version": "1.0.0",
  "description": "Description courte et claire",
  "icons": {
    "16": "icons/icon-16.png",
    "48": "icons/icon-48.png",
    "128": "icons/icon-128.png"
  },
  "action": {
    "default_popup": "popup/popup.html",
    "default_icon": "icons/icon-48.png",
    "default_title": "Mon Extension"
  },
  "background": {
    "service_worker": "background.js",
    "type": "module"
  },
  "content_scripts": [
    {
      "matches": ["https://*/*"],
      "js": ["content.js"],
      "css": ["content.css"],
      "run_at": "document_idle"
    }
  ],
  "permissions": ["storage", "activeTab"],
  "host_permissions": ["https://*.example.com/*"],
  "options_page": "options/options.html"
}
```

Pour les détails sur chaque champ et toutes les APIs disponibles, consulter `references/apis-reference.md`.

---

## Messaging — Communication entre composants

C'est le concept le plus important à maîtriser. Les scripts s'exécutent dans des contextes isolés et communiquent via messages.

### One-shot message (request → response)

```javascript
// --- DEPUIS popup.js ou content.js → service worker ---
chrome.runtime.sendMessage({ action: "getData", key: "user" }, (response) => {
  console.log("Réponse:", response);
});

// --- DANS background.js (service worker) → écoute ---
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === "getData") {
    chrome.storage.local.get(message.key, (data) => {
      sendResponse({ success: true, data: data[message.key] });
    });
    return true; // ← IMPORTANT : indique une réponse asynchrone
  }
});
```

### Message vers un onglet spécifique (SW → content script)

```javascript
// --- DANS background.js ---
chrome.tabs.sendMessage(tabId, { action: "highlight", selector: ".title" });

// --- DANS content.js ---
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  if (message.action === "highlight") {
    document.querySelector(message.selector)?.style.backgroundColor = "yellow";
    sendResponse({ done: true });
  }
});
```

### Long-lived connection (port)

```javascript
// --- Côté émetteur ---
const port = chrome.runtime.connect({ name: "stream" });
port.postMessage({ type: "start" });
port.onMessage.addListener((msg) => console.log(msg));

// --- Côté récepteur (background.js) ---
chrome.runtime.onConnect.addListener((port) => {
  if (port.name === "stream") {
    port.onMessage.addListener((msg) => {
      port.postMessage({ type: "data", payload: "..." });
    });
  }
});
```

---

## Storage — Persistance des données

```javascript
// Écriture
chrome.storage.local.set({ settings: { theme: "dark", lang: "fr" } });

// Lecture
chrome.storage.local.get("settings", (result) => {
  const settings = result.settings || {};
});

// Écoute des changements (fonctionne dans TOUS les contextes)
chrome.storage.onChanged.addListener((changes, area) => {
  if (area === "local" && changes.settings) {
    console.log("Ancien:", changes.settings.oldValue);
    console.log("Nouveau:", changes.settings.newValue);
  }
});
```

| Type | Capacité | Sync entre appareils | Usage |
|---|---|---|---|
| `chrome.storage.local` | ~10 MB | Non | Données volumineuses, cache |
| `chrome.storage.sync` | ~100 KB | Oui (compte Google) | Préférences utilisateur |
| `chrome.storage.session` | ~10 MB | Non, effacé à la fermeture | État temporaire (remplace les variables globales du SW) |

---

## Structure de fichiers recommandée

```
mon-extension/
├── manifest.json
├── background.js              ← Service worker
├── content.js                 ← Content script
├── content.css                ← Styles injectés
├── popup/
│   ├── popup.html
│   ├── popup.js
│   └── popup.css
├── options/
│   ├── options.html
│   ├── options.js
│   └── options.css
├── utils/
│   └── helpers.js             ← Utilitaires partagés
├── icons/
│   ├── icon-16.png
│   ├── icon-48.png
│   └── icon-128.png
└── README.md
```

**Pour les extensions multi-modules** (comme SwissKit) :
```
swisskit/
├── manifest.json
├── background.js              ← Router central de messages
├── modules/
│   ├── module-a/
│   │   ├── content.js
│   │   └── styles.css
│   ├── module-b/
│   │   ├── content.js
│   │   └── styles.css
│   └── module-c/
│       └── content.js
├── popup/
│   ├── popup.html             ← Menu principal avec toggles par module
│   └── popup.js
├── shared/
│   ├── storage.js             ← Wrapper chrome.storage
│   └── messaging.js           ← Helpers de messaging
└── icons/
```

---

## Debugging — Guide rapide

### Charger l'extension en dev
1. Aller à `chrome://extensions`
2. Activer le "Mode développeur" (toggle en haut à droite)
3. Cliquer "Charger l'extension non empaquetée"
4. Sélectionner le dossier de l'extension

### Debugger chaque composant

| Composant | Comment debugger |
|---|---|
| **Popup** | Clic droit sur le popup → "Inspecter" |
| **Content script** | DevTools de la page (F12) → Console → filtrer par contexte d'extension |
| **Service worker** | `chrome://extensions` → clic sur "Service Worker" sous l'extension |
| **Options page** | Comme une page web normale (F12) |

### Erreurs courantes

| Erreur | Cause probable | Fix |
|---|---|---|
| `Unchecked runtime.lastError` | Message envoyé, pas de listener | Vérifier que le listener existe et renvoie `true` si async |
| `Cannot access chrome.tabs` | Permission manquante | Ajouter `"tabs"` dans permissions |
| Service worker qui s'éteint | État stocké en variable | Migrer vers `chrome.storage.session` |
| Content script pas injecté | `matches` pattern incorrect | Vérifier les URL patterns dans le manifest |
| CSP violation | Script externe ou inline | Tout le JS doit être dans des fichiers locaux |

---

## Publication sur le Chrome Web Store

### Checklist pré-publication
- [ ] `manifest.json` complet et valide
- [ ] Icons : 16×16, 48×48, 128×128 (PNG)
- [ ] Screenshots : au moins 1 (1280×800 ou 640×400)
- [ ] Description courte + détaillée
- [ ] Privacy policy (obligatoire si permissions sensibles)
- [ ] Permissions minimales (principe du moindre privilège)
- [ ] Tester sur Chrome stable

### Packager
```bash
# Depuis le dossier parent de l'extension
zip -r extension.zip mon-extension/ -x "*.git*" "node_modules/*" ".DS_Store" "*.md"
```

### Process de review
- Frais uniques : 5$ pour le compte développeur
- Durée de review : généralement 1-3 jours
- Rejets fréquents : permissions trop larges, description vague, pas de privacy policy

---

## Patterns avancés

### Injection de script programmatique (MV3)
```javascript
// Dans le service worker — injecter du code dans l'onglet actif
chrome.action.onClicked.addListener(async (tab) => {
  await chrome.scripting.executeScript({
    target: { tabId: tab.id },
    func: () => {
      document.body.style.backgroundColor = "#f0f0f0";
    },
  });
});
// Permission requise : "scripting" + "activeTab"
```

### Alarmes (remplace setInterval dans le SW)
```javascript
// Créer une alarme récurrente
chrome.alarms.create("refresh", { periodInMinutes: 30 });

// Écouter
chrome.alarms.onAlarm.addListener((alarm) => {
  if (alarm.name === "refresh") {
    fetchLatestData();
  }
});
// Permission requise : "alarms"
```

### Context menu (clic droit)
```javascript
// Dans background.js — une seule fois à l'installation
chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: "search-selection",
    title: "Rechercher '%s'",
    contexts: ["selection"],
  });
});

chrome.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === "search-selection") {
    chrome.tabs.create({ url: `https://google.com/search?q=${info.selectionText}` });
  }
});
// Permission requise : "contextMenus"
```

### Badge sur l'icône
```javascript
chrome.action.setBadgeText({ text: "3" });
chrome.action.setBadgeBackgroundColor({ color: "#6366f1" });
```

---

## Ce qu'on ne fait PAS

- ❌ Code remotely hosted (interdit en MV3 — tout doit être dans le package)
- ❌ `eval()`, `new Function()`, inline scripts dans le HTML
- ❌ Stocker de l'état dans des variables globales du service worker
- ❌ Permissions excessives (demander `"<all_urls>"` sans raison)
- ❌ `chrome.webRequest` bloquant (remplacé par `declarativeNetRequest`)
- ❌ Manifest V2 (obsolète, plus accepté sur le Chrome Web Store)

---

## Ressources

- Documentation officielle : https://developer.chrome.com/docs/extensions
- API Reference : https://developer.chrome.com/docs/extensions/reference/api
- Manifest V3 migration : https://developer.chrome.com/docs/extensions/develop/migrate
- Exemples officiels : https://github.com/GoogleChrome/chrome-extensions-samples
