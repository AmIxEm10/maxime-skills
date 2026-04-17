---
name: rapport
description: "Génère des rapports académiques, comptes-rendus de TP/SAÉ, et livrables scolaires à partir de sujets de cours, d'énoncés, de grilles d'évaluation, de notes de cours ou de consignes. Utilise ce skill dès que l'utilisateur mentionne 'rapport', 'compte-rendu', 'CR', 'livrable', 'TP', 'SAÉ', 'rendu', 'dossier', 'mémoire', 'rédiger un rapport', 'faire un CR', 'grille d'évaluation', 'barème', 'note de synthèse', ou tout document académique structuré à rendre pour un cours ou un projet universitaire. Utilise-le aussi quand l'utilisateur uploade un sujet de TP, un énoncé de SAÉ, une grille de notation, ou des consignes de rendu — même s'il ne dit pas explicitement 'rapport'. Ce skill couvre les formats BUT/IUT, licence, et école d'ingénieur."
---

# Rapport — Générateur de rapports académiques

## Objectif

Produire des rapports académiques de qualité professionnelle à partir de matériaux bruts fournis par l'étudiant : énoncés de TP, sujets de SAÉ, grilles d'évaluation, notes de cours, données expérimentales, photos, etc.

Le rapport généré doit être **prêt à rendre** : structuré, formaté, et calibré pour obtenir la meilleure note possible selon la grille d'évaluation fournie.

---

## Workflow

### Étape 1 — Analyse des entrées

Avant toute rédaction, identifier et analyser TOUS les documents fournis :

| Type d'entrée | Ce qu'on en extrait |
|---|---|
| **Énoncé / Sujet** | Objectifs, livrables attendus, contraintes, questions à traiter |
| **Grille d'évaluation / Barème** | Critères notés, pondération, attentes implicites du correcteur |
| **Notes de cours / Slides** | Vocabulaire technique attendu, théorie à mobiliser, références |
| **Données expérimentales** | Résultats à présenter, analyser, interpréter |
| **Photos / Schémas** | Éléments visuels à intégrer et légender |
| **Consignes de rendu** | Format, longueur, plan imposé, date limite |

**RÈGLE CRITIQUE** : Si une grille d'évaluation est fournie, elle dicte la structure du rapport. Chaque critère noté = une section ou un point explicitement traité.

### Étape 2 — Structuration

Appliquer le plan approprié selon le type de rapport. Consulter `references/structures.md` pour les plans détaillés par type.

**Plan générique (défaut)** :

1. **Page de garde** — Titre, auteur(s), formation, date, encadrants
2. **Sommaire** — Généré automatiquement
3. **Introduction** — Contexte, objectifs, problématique, annonce du plan
4. **Développement** — Structuré selon l'énoncé/la grille
5. **Conclusion** — Synthèse, bilan personnel, ouverture
6. **Annexes** — Documents complémentaires, code source, données brutes

### Étape 3 — Rédaction

Appliquer les règles de rédaction suivantes :

#### Ton et style
- **Registre** : Soutenu mais pas pompeux. Phrases claires, directes.
- **Voix** : Première personne du pluriel ("Nous avons...", "Notre démarche...") sauf indication contraire.
- **Temps** : Passé composé pour les actions réalisées, présent pour l'analyse.
- **Vocabulaire** : Utiliser le jargon technique du domaine, issu des cours fournis.
- **Pas de remplissage** : Chaque phrase apporte de l'information. Pas de banalités ("De tout temps, l'homme...").

#### Contenu attendu par section
- **Introduction** : 
  - Contexte du projet/TP (en 2-3 phrases max)
  - Objectifs précis (reprendre ceux de l'énoncé, reformulés)
  - Problématique (si applicable)
  - Annonce du plan (1 phrase)
  
- **Parties de développement** :
  - Commencer chaque partie par une phrase de transition
  - Présenter la méthode/démarche AVANT les résultats
  - Résultats : données + analyse + interprétation (pas juste les données brutes)
  - Illustrer avec des figures, tableaux, schémas (numérotés et légendés)
  - Faire le lien avec la théorie vue en cours
  - Si grille : s'assurer que CHAQUE critère est explicitement adressé

- **Conclusion** :
  - Reformuler les objectifs initiaux
  - Résumer les résultats clés (pas de nouvelles infos)
  - Auto-évaluation / difficultés rencontrées (si demandé)
  - Ouverture pertinente (pas forcément une question, peut être une perspective)

#### Mise en forme
- Figures et tableaux : **numérotés** (Figure 1, Tableau 1...), avec **légende descriptive**
- Équations : numérotées si référencées dans le texte
- Unités SI, notation scientifique quand approprié
- Sources citées en note de bas de page ou en bibliographie

### Étape 4 — Optimisation par la grille

Si une grille d'évaluation est fournie :

1. **Lister** chaque critère et sa pondération
2. **Vérifier** que le rapport adresse EXPLICITEMENT chaque critère
3. **Renforcer** les sections correspondant aux critères les plus pondérés
4. **Ajouter** ce qui manque
5. **Auto-évaluer** : pour chaque critère, indiquer où dans le rapport il est traité

### Étape 5 — Génération du fichier

Utiliser le **skill docx** pour générer un `.docx` professionnel avec :
- Page de garde formatée
- Sommaire avec numérotation
- En-têtes et pieds de page (nom, titre, pagination)
- Styles cohérents (titres, corps, légendes)
- Tableaux et figures intégrés

⚠️ Toujours lire le SKILL.md du skill `docx` avant de générer le fichier Word.

---

## Types de rapports supportés

Pour les plans détaillés de chaque type, consulter `references/structures.md`.

| Type | Déclencheur | Spécificités |
|---|---|---|
| **Compte-rendu de TP** | "CR de TP", "rapport TP" | Protocole → Résultats → Analyse |
| **Rapport de SAÉ** | "SAÉ", "situation d'apprentissage" | Gestion de projet, travail en groupe, compétences BUT |
| **Rapport de stage / alternance** | "rapport alternance", "mémoire stage" | Présentation entreprise, missions, bilan compétences |
| **Dossier technique** | "dossier", "étude technique" | Cahier des charges, solutions, dimensionnement |
| **Note de synthèse** | "synthèse", "résumé" | Concis, structuré, pas de partie personnelle |
| **Présentation de projet** | "soutenance", "oral" | Support visuel, notes orateur |

---

## Adaptation au niveau

Le rapport s'adapte automatiquement au contexte détecté :

- **BUT / IUT** : Focus compétences, vocabulaire accessible, lien avec le référentiel
- **Licence** : Plus académique, bibliographie attendue
- **École d'ingénieur** : Rigueur technique, analyse critique, dimensionnement

---

## Anti-patterns à éviter

❌ Copier-coller l'énoncé comme contenu du rapport
❌ Introduction générique sans lien avec le sujet
❌ Conclusion qui répète mot pour mot l'introduction
❌ Figures sans légende ni numérotation
❌ Résultats sans analyse ni interprétation
❌ Ignorer des critères de la grille d'évaluation
❌ Remplissage (paragraphes creux, phrases bateau)
❌ Plan non adapté à l'énoncé (forcer un plan générique)
❌ Oublier les unités ou les incertitudes de mesure
❌ Ne pas citer ses sources

---

## Checklist finale (avant livraison)

Avant de livrer le rapport, vérifier :

- [ ] Page de garde complète (titre, noms, date, formation, encadrants)
- [ ] Sommaire avec numérotation correcte
- [ ] Introduction avec objectifs + annonce du plan
- [ ] CHAQUE critère de la grille est adressé (si grille fournie)
- [ ] Figures et tableaux numérotés et légendés
- [ ] Résultats analysés ET interprétés (pas juste posés)
- [ ] Lien avec la théorie / les cours
- [ ] Conclusion avec synthèse + ouverture
- [ ] Orthographe et grammaire vérifiées
- [ ] Format de rendu respecté (nombre de pages, police, marges)
- [ ] Fichier .docx généré et fonctionnel

---

## Interaction avec l'utilisateur

Quand l'utilisateur demande un rapport :

1. **Identifier le type** de rapport (TP, SAÉ, stage, etc.)
2. **Demander ce qui manque** si les entrées sont insuffisantes :
   - "Tu as la grille d'évaluation ?"
   - "Il y a des consignes sur le format (pages, plan imposé) ?"
   - "Tu as des résultats expérimentaux / données à intégrer ?"
3. **Proposer un plan** avant de rédiger (sauf si l'utilisateur veut aller vite)
4. **Générer le rapport** en `.docx`
5. **Fournir une auto-évaluation** par rapport à la grille si elle existe

Ne jamais générer un rapport incomplet sans prévenir. Si des informations cruciales manquent, le signaler clairement et proposer des alternatives (hypothèses, sections à compléter marquées [À COMPLÉTER]).
