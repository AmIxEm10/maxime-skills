---
name: portfolio-builder
description: "Crée des composants, sections, visuels et contenus pour un portfolio web élégant et moderne. Utilise ce skill dès que l'utilisateur mentionne son portfolio, sa soutenance, ses compétences BUT, un composant de portfolio, une section de projet, une animation, un radar chart, une timeline, une carte projet, un badge, ou tout élément visuel/textuel destiné à un portfolio développeur ou étudiant. Utilise-le aussi quand l'utilisateur demande de rédiger des descriptions de compétences, des textes de présentation de projets, ou du contenu pour un jury de soutenance — même s'il ne mentionne pas explicitement le mot 'portfolio'."
---

# Portfolio Builder

**Purpose:** Générer des composants visuels, des animations fluides, des contenus textuels et des éléments de design pour un portfolio web moderne et élégant. Esthétique classique et soignée avec des animations raffinées.

---

## Contexte du portfolio

Le portfolio cible sert à la fois de **vitrine professionnelle** et de **support de soutenance BUT3 GMP** (parcours CPD — Conception et Production Durables). Il intègre :

- Des radar charts de compétences
- Une timeline d'alternance
- Des cartes de projets interactives
- Des animations d'entrée fluides et professionnelles
- Une esthétique classique, épurée et moderne (inspirée Vercel, Linear, Stripe)

---

## Design System de référence

Avant de générer tout composant visuel, consulter `references/design-system.md` pour les tokens de design (couleurs, typographie, espacements, animations, ombres).

---

## Workflow selon le type de demande

### 1. Composant React interactif

Quand l'utilisateur demande un composant interactif (chart, animation, widget) :

1. **Identifier le type** : composant React UI, graphique, animation, widget interactif
2. **Consulter** `references/design-system.md` pour les tokens visuels
3. **Générer** un artifact React (`.jsx`) prévisualisable inline OU du code HTML/CSS/JS prêt à intégrer selon la demande
4. **Inclure** : animations d'entrée fluides, états hover/focus soignés, responsive, accessibilité
5. **Respecter l'esthétique** : classique, épuré, pas de design générique ni surchargé

**Librairies disponibles en artifact React :**
- `recharts` pour les graphiques (radar charts, bar charts)
- `d3` pour les visualisations avancées
- `three` (r128) pour les scènes 3D si demandé
- `lucide-react` pour les icônes
- `lodash` pour les utilitaires
- Tailwind CSS (classes utilitaires uniquement)

**Contraintes artifacts :**
- Pas de `localStorage` / `sessionStorage`
- Tout en un seul fichier
- Import React hooks : `import { useState, useEffect, useRef } from "react"`
- Export par défaut obligatoire
- Pour Three.js : pas de `CapsuleGeometry`, pas d'`OrbitControls` direct

### 2. Section de contenu textuel

Quand l'utilisateur demande du contenu (description de compétence, texte de projet, bio) :

1. **Identifier le contexte** : soutenance BUT3, portfolio web, CV, LinkedIn
2. **Si soutenance** : consulter `references/but-gmp-competences.md` pour le référentiel officiel
3. **Adapter le ton** :
   - Soutenance/jury → formel, démonstratif, axé preuves et résultats
   - Portfolio web → concis, impactant, storytelling technique
   - CV/LinkedIn → professionnel, mots-clés, résultats mesurables
4. **Structure pour une compétence** :
   - Intitulé officiel (référentiel BUT)
   - Contexte de mise en œuvre (projet, entreprise, SAÉ)
   - Composantes essentielles mobilisées
   - Actions concrètes réalisées
   - Résultats / livrables / métriques
   - Outils et méthodes utilisés
5. **Structure pour un projet** :
   - Titre + tagline (1 ligne)
   - Problème / contexte
   - Solution technique (stack, architecture)
   - Résultats / impact
   - Ce que j'ai appris

### 3. Visuel statique (SVG, carte, badge)

Quand l'utilisateur demande un élément graphique :

1. **Identifier le type** : carte projet, badge, icône, séparateur, illustration
2. **Générer en SVG** ou React selon la complexité
3. **Respecter le design system** : couleurs, ombres, typographie
4. **Garder la sobriété** : pas de surcharge visuelle, chaque élément a sa raison d'être

---

## Principes esthétiques

### Ce qu'on fait
- **Épuré et lisible** : beaucoup d'espace négatif, hiérarchie visuelle claire
- **Typographie soignée** : Inter ou Plus Jakarta Sans, poids bien contrastés, tracking ajusté
- **Animations fluides** : reveals au scroll (translateY + opacity), staggers doux (0.06s entre enfants), hovers subtils (lift + shadow)
- **Ombres douces** : shadows progressives qui donnent de la profondeur sans lourdeur
- **Couleurs mesurées** : palette neutre sombre + un accent indigo utilisé avec parcimonie
- **Bordures subtiles** : 1px rgba très léger pour structurer sans alourdir
- **Interactivité soignée** : hover states, focus rings, transitions smooth sur tout

### Ce qu'on ne fait PAS
- ❌ Effets glitch, scan lines, grain, halftone, speed lines
- ❌ Néon, glow excessif, couleurs criardes
- ❌ Polices display/excentriques pour le texte courant
- ❌ Animations brusques ou trop longues (> 1s)
- ❌ Fond trop chargé (textures lourdes, particules décoratives sans but)
- ❌ Design "template" sans personnalité (mais pas de surcharge non plus)

### L'équilibre visé
> Classique ne veut pas dire ennuyeux. La beauté vient de la précision : un spacing parfait, une animation au bon timing, une ombre bien dosée, un accent de couleur placé juste là où il faut.

---

## Templates de composants fréquents

### Radar Chart de compétences
- Utiliser `recharts` RadarChart
- Fond sombre, grille subtile, trait accent indigo
- Points lumineux mais pas flashy
- Tooltip au hover avec détail de la compétence
- Animation d'entrée du tracé (1-1.5s, ease-decelerate)

### Timeline d'alternance
- Layout vertical avec ligne centrale fine
- Nodes circulaires avec icône ou date
- Cards alternées gauche/droite (ou toutes à droite en mobile)
- Reveal staggeré au scroll
- Contenu : période, intitulé, description courte, compétences liées

### Carte projet
- Image/preview en haut + contenu en bas
- Stack technique en badges discrets
- Description 2-3 lignes max
- Hover : lift (-4px) + ombre accent + border légèrement plus visible
- Variantes : grille (compacte) et featured (large)

### Hero section
- Titre large (font-display, weight 800, tracking serré)
- Sous-titre en text-secondary
- CTA bouton accent
- Animation d'entrée : titre puis sous-titre puis CTA (stagger 0.15s)
- Fond : dégradé très subtil ou simple couleur unie

### Section "À propos"
- Bio concise, ton confiant
- Tags de compétences en badges
- Liens sociaux (icônes lucide-react)
- Layout simple : texte à gauche, éventuellement photo/avatar à droite

---

## Consignes de rédaction

### Pour la soutenance BUT3
- Vocabulaire du référentiel BUT GMP officiel
- Démontrer avec des **preuves concrètes**
- Méthode STAR : situation → tâche → action → résultat
- Mentionner outils spécifiques (logiciels, instruments, normes ISO)
- Relier chaque réalisation aux compétences et composantes essentielles du référentiel

### Pour le portfolio web
- Phrases courtes et percutantes
- Commencer par le résultat, pas le contexte
- Verbes d'action : "Conçu", "Développé", "Optimisé", "Automatisé"
- Métriques quand possible
- 2-3 lignes max en carte, 1 paragraphe en vue détaillée

### Ton général
- Confiant sans arrogance
- Technique mais accessible
- Professionnel et mature
- Bilingue si demandé (français principal, anglais technique)
