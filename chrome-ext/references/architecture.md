# Architecture — Patterns d'extensions Chrome

## Choisir les bons composants

| Tu veux... | Composant nécessaire |
|---|---|
| Un bouton dans la toolbar avec un menu | Popup |
| Modifier le contenu d'une page web | Content script |
| Réagir à des événements navigateur (install, navigation, alarm) | Service worker |
| Stocker des préférences utilisateur | Storage + Options page |
| Un panneau latéral permanent | Side panel |
| Un menu clic-droit | Context menu (dans le SW) |
| Intercepter/modifier des requêtes réseau | declarativeNetRequest |
| Faire du parsing DOM en arrière-plan | Offscreen document |

---

## Patterns d'architecture courants

### Pattern 1 : Extension simple (popup-only)
```
Cas : outil autonome (calculatrice, générateur, convertisseur)
Composants : manifest + popup
Pas de content script, pas de service worker complexe

manifest.json
popup/
  popup.html
  popup.js
  popup.css
```

### Pattern 2 : Modificateur de page
```
Cas : modifier l'apparence ou le contenu d'un site (dark mode, ad tweaks, UI enhancements)
Composants : manifest + content script + popup (toggle on/off)

manifest.json
content.js          ← Injecté dans les pages ciblées
content.css         ← Styles injectés
popup/
  popup.html        ← Toggle on/off, réglages rapides
  popup.js
background.js       ← Gère l'état on/off via storage
```

### Pattern 3 : Extension multi-modules (type SwissKit)
```
Cas : plusieurs fonctionnalités indépendantes regroupées
Composants : manifest + SW routeur + modules content scripts + popup manager

manifest.json
background.js           ← Routeur : active/désactive les modules
modules/
  dark-mode/
    content.js
    styles.css
  link-checker/
    content.js
  note-taker/
    content.js
popup/
  popup.html            ← Dashboard avec toggles par module
  popup.js
shared/
  storage.js            ← CRUD wrapper chrome.storage
  messaging.js          ← Helpers sendMessage/onMessage
```

### Pattern 4 : Extension avec side panel
```
Cas : outil de référence permanent (notes, traductions, documentation)
Composants : manifest + side panel + content script (optionnel)

manifest.json
background.js
sidepanel/
  panel.html
  panel.js
  panel.css
content.js              ← Optionnel : extraire des données de la page
```

### Pattern 5 : Extension API-connected
```
Cas : l'extension communique avec un backend/API externe
Composants : manifest + SW (fetch API) + popup + storage

manifest.json
background.js           ← Fetch vers l'API, cache dans storage
popup/
  popup.html            ← Affiche les données
  popup.js
options/
  options.html          ← Config API key, préférences
  options.js
```

---

## Templates de fichiers

### Popup HTML minimal
```html
<!DOCTYPE html>
<html lang="fr">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <link rel="stylesheet" href="popup.css">
  <title>Mon Extension</title>
</head>
<body>
  <div id="app">
    <h1>Mon Extension</h1>
    <div id="content"></div>
  </div>
  <script src="popup.js"></script>
</body>
</html>
```

### Service worker minimal
```javascript
// background.js

// Initialisation
chrome.runtime.onInstalled.addListener(({ reason }) => {
  if (reason === "install") {
    console.log("Extension installée");
    chrome.storage.local.set({ enabled: true, settings: {} });
  }
});

// Écoute des messages
chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
  switch (message.action) {
    case "getState":
      chrome.storage.local.get(null, (data) => sendResponse(data));
      return true; // async

    case "toggle":
      chrome.storage.local.get("enabled", ({ enabled }) => {
        chrome.storage.local.set({ enabled: !enabled });
        sendResponse({ enabled: !enabled });
      });
      return true;

    default:
      sendResponse({ error: "Action inconnue" });
  }
});
```

### Content script minimal
```javascript
// content.js

(function() {
  "use strict";

  // Vérifier si déjà injecté (évite les doublons)
  if (window.__myExtensionLoaded) return;
  window.__myExtensionLoaded = true;

  // Attendre que le DOM soit prêt
  function init() {
    console.log("Extension chargée sur", window.location.href);
    // ... logique ici
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }

  // Écouter les messages du SW ou popup
  chrome.runtime.onMessage.addListener((message, sender, sendResponse) => {
    // ...
    sendResponse({ ok: true });
  });
})();
```

### Storage wrapper réutilisable
```javascript
// shared/storage.js

export const Storage = {
  async get(key) {
    const result = await chrome.storage.local.get(key);
    return key ? result[key] : result;
  },

  async set(key, value) {
    if (typeof key === "object") {
      return chrome.storage.local.set(key);
    }
    return chrome.storage.local.set({ [key]: value });
  },

  async remove(key) {
    return chrome.storage.local.remove(key);
  },

  onChange(callback) {
    chrome.storage.onChanged.addListener((changes, area) => {
      if (area === "local") callback(changes);
    });
  },
};
```

---

## Pièges fréquents et solutions

### 1. Service worker qui perd son état
```javascript
// ❌ MAUVAIS — variable perdue quand le SW s'éteint
let counter = 0;
chrome.action.onClicked.addListener(() => {
  counter++;  // Repart à 0 après chaque réveil
});

// ✅ BON — persisté dans storage.session
chrome.action.onClicked.addListener(async () => {
  const { counter = 0 } = await chrome.storage.session.get("counter");
  await chrome.storage.session.set({ counter: counter + 1 });
});
```

### 2. sendResponse asynchrone
```javascript
// ❌ MAUVAIS — sendResponse appelé après que le listener ait retourné
chrome.runtime.onMessage.addListener((msg, sender, sendResponse) => {
  fetch("https://api.com/data").then(r => r.json()).then(sendResponse);
  // Le listener retourne undefined → le canal se ferme
});

// ✅ BON — return true garde le canal ouvert
chrome.runtime.onMessage.addListener((msg, sender, sendResponse) => {
  fetch("https://api.com/data").then(r => r.json()).then(sendResponse);
  return true; // ← Indispensable pour les réponses async
});
```

### 3. Content script et SPA (Single Page Apps)
```javascript
// Les SPA changent de "page" sans recharger → le content script ne se réinjecte pas
// Solution : observer les changements d'URL

let lastUrl = location.href;
new MutationObserver(() => {
  if (location.href !== lastUrl) {
    lastUrl = location.href;
    onUrlChange(); // Re-appliquer la logique
  }
}).observe(document.body, { childList: true, subtree: true });
```

### 4. CORS dans le service worker
```javascript
// Le SW peut faire des fetch cross-origin SI host_permissions le permet
// Pas besoin de proxy CORS si l'URL est dans host_permissions

// manifest.json :
// "host_permissions": ["https://api.example.com/*"]

// background.js :
const response = await fetch("https://api.example.com/data"); // ✅ OK
```
