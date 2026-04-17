# Chrome APIs Reference — Manifest V3

## Permissions et APIs correspondantes

### Permissions courantes

| Permission | API débloquée | Usage | Sensibilité |
|---|---|---|---|
| `"activeTab"` | Accès temporaire à l'onglet actif | Agir sur la page en cours au clic utilisateur | Faible |
| `"tabs"` | `chrome.tabs` complet | Lister, créer, modifier, fermer des onglets | Moyenne |
| `"storage"` | `chrome.storage` | Stockage local/sync/session | Faible |
| `"alarms"` | `chrome.alarms` | Tâches planifiées récurrentes | Faible |
| `"contextMenus"` | `chrome.contextMenus` | Menus clic-droit personnalisés | Faible |
| `"scripting"` | `chrome.scripting` | Injection de scripts programmatique | Moyenne |
| `"notifications"` | `chrome.notifications` | Notifications système | Faible |
| `"bookmarks"` | `chrome.bookmarks` | CRUD sur les favoris | Moyenne |
| `"history"` | `chrome.history` | Accès à l'historique de navigation | Haute |
| `"downloads"` | `chrome.downloads` | Gérer les téléchargements | Moyenne |
| `"cookies"` | `chrome.cookies` | Lire/écrire les cookies | Haute |
| `"webNavigation"` | `chrome.webNavigation` | Événements de navigation | Moyenne |
| `"declarativeNetRequest"` | `chrome.declarativeNetRequest` | Modifier/bloquer des requêtes réseau | Haute |
| `"identity"` | `chrome.identity` | OAuth2 / authentification Google | Moyenne |
| `"sidePanel"` | `chrome.sidePanel` | Panneau latéral | Faible |
| `"offscreen"` | `chrome.offscreen` | Document hors écran (audio, DOM parsing) | Faible |
| `"clipboardRead"` | Accès presse-papier (lecture) | Lire le contenu copié | Haute |
| `"clipboardWrite"` | Accès presse-papier (écriture) | Écrire dans le presse-papier | Faible |

### Host permissions (séparées du tableau permissions)

```json
"host_permissions": [
  "https://*.example.com/*",
  "https://api.monservice.com/*"
]
```

Patterns supportés :
- `"https://*/*"` — tous les sites HTTPS
- `"http://*/*"` — tous les sites HTTP
- `"<all_urls>"` — tout (éviter si possible, flag de review)
- `"https://*.github.com/*"` — sous-domaines GitHub
- `"https://specific-site.com/api/*"` — chemin spécifique

---

## APIs détaillées par catégorie

### chrome.tabs
```javascript
// Obtenir l'onglet actif
const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });

// Créer un onglet
chrome.tabs.create({ url: "https://example.com", active: true });

// Mettre à jour un onglet
chrome.tabs.update(tabId, { url: "https://new-url.com" });

// Écouter les changements d'URL
chrome.tabs.onUpdated.addListener((tabId, changeInfo, tab) => {
  if (changeInfo.url) {
    console.log("Nouvelle URL:", changeInfo.url);
  }
});

// Fermer un onglet
chrome.tabs.remove(tabId);
```

### chrome.storage
```javascript
// --- local (10 MB, pas de sync) ---
await chrome.storage.local.set({ key: "value" });
const result = await chrome.storage.local.get("key");
const all = await chrome.storage.local.get(null); // tout récupérer
await chrome.storage.local.remove("key");
await chrome.storage.local.clear();

// --- sync (100 KB, synchronisé entre appareils) ---
await chrome.storage.sync.set({ preferences: { theme: "dark" } });

// --- session (éphémère, survit au réveil du SW, effacé à la fermeture du navigateur) ---
await chrome.storage.session.set({ tempData: [1, 2, 3] });

// Écouter les changements (tous contextes)
chrome.storage.onChanged.addListener((changes, area) => {
  for (const [key, { oldValue, newValue }] of Object.entries(changes)) {
    console.log(`${area}.${key}: ${oldValue} → ${newValue}`);
  }
});
```

### chrome.scripting
```javascript
// Injecter une fonction
await chrome.scripting.executeScript({
  target: { tabId },
  func: (color) => { document.body.style.backgroundColor = color; },
  args: ["#f0f0f0"],
});

// Injecter un fichier
await chrome.scripting.executeScript({
  target: { tabId },
  files: ["inject.js"],
});

// Injecter du CSS
await chrome.scripting.insertCSS({
  target: { tabId },
  css: "body { font-size: 18px !important; }",
});

// Retirer du CSS injecté
await chrome.scripting.removeCSS({
  target: { tabId },
  css: "body { font-size: 18px !important; }",
});
```

### chrome.runtime
```javascript
// Événement d'installation / mise à jour
chrome.runtime.onInstalled.addListener((details) => {
  if (details.reason === "install") {
    // Premier lancement — initialiser le storage
    chrome.storage.local.set({ version: "1.0.0", firstRun: true });
  } else if (details.reason === "update") {
    // Mise à jour — migration de données si nécessaire
    console.log("Mise à jour depuis", details.previousVersion);
  }
});

// Ouvrir la page d'options
chrome.runtime.openOptionsPage();

// Obtenir l'URL d'une ressource de l'extension
const url = chrome.runtime.getURL("images/logo.png");
```

### chrome.action (remplace chrome.browserAction de MV2)
```javascript
// Badge
chrome.action.setBadgeText({ text: "5" });
chrome.action.setBadgeBackgroundColor({ color: "#ef4444" });
chrome.action.setBadgeTextColor({ color: "#ffffff" });

// Tooltip
chrome.action.setTitle({ title: "5 notifications" });

// Changer l'icône dynamiquement
chrome.action.setIcon({ path: "icons/active-48.png" });

// Désactiver le bouton pour certains onglets
chrome.action.disable(tabId);
chrome.action.enable(tabId);

// Écouter le clic (si PAS de popup défini)
chrome.action.onClicked.addListener((tab) => {
  // Action au clic sur l'icône
});
```

### chrome.alarms
```javascript
// Créer (remplace setInterval qui ne survit pas au SW shutdown)
chrome.alarms.create("check-updates", {
  delayInMinutes: 1,        // premier déclenchement
  periodInMinutes: 30,       // récurrence
});

// One-shot
chrome.alarms.create("reminder", { delayInMinutes: 5 });

// Écouter
chrome.alarms.onAlarm.addListener((alarm) => {
  switch (alarm.name) {
    case "check-updates": fetchUpdates(); break;
    case "reminder": showNotification(); break;
  }
});

// Supprimer
chrome.alarms.clear("check-updates");
chrome.alarms.clearAll();
```

### chrome.contextMenus
```javascript
// Créer (dans onInstalled uniquement)
chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: "translate",
    title: "Traduire '%s'",
    contexts: ["selection"],     // selection, page, link, image, video, audio
  });

  chrome.contextMenus.create({
    id: "save-image",
    title: "Sauvegarder l'image",
    contexts: ["image"],
  });
});

// Écouter
chrome.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === "translate") {
    const text = info.selectionText;
    // ...
  }
});
```

### chrome.notifications
```javascript
chrome.notifications.create("notif-id", {
  type: "basic",
  iconUrl: "icons/icon-128.png",
  title: "Titre de la notification",
  message: "Corps du message",
  priority: 2,
});

// Avec boutons
chrome.notifications.create("action-notif", {
  type: "basic",
  iconUrl: "icons/icon-128.png",
  title: "Nouveau message",
  message: "Voulez-vous répondre ?",
  buttons: [
    { title: "Répondre" },
    { title: "Ignorer" },
  ],
});

chrome.notifications.onButtonClicked.addListener((notifId, btnIdx) => {
  if (notifId === "action-notif" && btnIdx === 0) {
    // Répondre
  }
});
```

### chrome.sidePanel
```json
// manifest.json
{
  "side_panel": {
    "default_path": "sidepanel/panel.html"
  },
  "permissions": ["sidePanel"]
}
```

```javascript
// Ouvrir programmatiquement
chrome.sidePanel.open({ tabId });

// Configurer par onglet
chrome.sidePanel.setOptions({
  tabId,
  path: "sidepanel/custom-panel.html",
  enabled: true,
});
```

---

## Content Security Policy (CSP)

MV3 impose une CSP stricte par défaut :
- ❌ Pas de scripts inline (`<script>alert(1)</script>`)
- ❌ Pas de `eval()`, `new Function()`, `setTimeout("code")`
- ❌ Pas de scripts depuis des CDN externes
- ✅ Tout le JS dans des fichiers `.js` locaux
- ✅ Import de modules avec `type="module"` dans le manifest

Pour personnaliser (rarement nécessaire) :
```json
{
  "content_security_policy": {
    "extension_pages": "script-src 'self'; object-src 'self'"
  }
}
```

---

## Content Scripts — URL Patterns

```json
"content_scripts": [
  {
    "matches": ["https://*.github.com/*"],
    "exclude_matches": ["https://github.com/settings/*"],
    "js": ["content.js"],
    "css": ["content.css"],
    "run_at": "document_idle",
    "all_frames": false
  }
]
```

| `run_at` | Quand | Usage |
|---|---|---|
| `"document_idle"` | Après le chargement complet (défaut) | La plupart des cas |
| `"document_end"` | Après le DOM, avant les sous-ressources | Manipulation DOM rapide |
| `"document_start"` | Avant tout le reste | Injection de styles, override de variables |

---

## Offscreen Documents (MV3)

Pour les tâches nécessitant un DOM (parsing HTML, audio, clipboard) :

```javascript
// Créer un document offscreen
await chrome.offscreen.createDocument({
  url: "offscreen.html",
  reasons: ["DOM_PARSER"],      // ou AUDIO_PLAYBACK, CLIPBOARD, etc.
  justification: "Parse du HTML reçu via API",
});

// Communiquer via messaging standard
chrome.runtime.sendMessage({ target: "offscreen", html: "<div>...</div>" });
```
