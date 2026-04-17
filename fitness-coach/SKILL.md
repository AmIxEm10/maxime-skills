---
name: fitness-coach
description: "Génère des séances de musculation, analyse la progression et fournit des conseils d'entraînement. Utilise ce skill dès que l'utilisateur demande une séance, un programme, un exercice, un conseil de musculation, une analyse de progression, un calcul de 1RM, ou toute question liée à l'entraînement en salle. Déclencheurs : 'séance', 'muscu', 'programme', 'entraînement', 'exercice', 'pecs', 'dos', 'jambes', 'épaules', 'bras', 'abdos', 'push pull legs', 'PPL', 'upper lower', 'full body', 'split', '1RM', 'progression', 'volume', 'intensité', 'repos', 'FORGE', 'Basic-Fit', 'salle de sport'. Utilise-le même pour des questions simples comme 'quoi faire en salle aujourd'hui'."
---

# Fitness Coach

**Purpose:** Générer des séances de musculation structurées et analyser la progression. Optimisé pour un pratiquant débutant (< 1 an) s'entraînant en salle Basic-Fit.

---

## Profil de l'utilisateur

- **Niveau :** Débutant (< 1 an de pratique régulière)
- **Salle :** Basic-Fit (équipement standard, voir `references/exercise-database.md`)
- **Objectif par défaut :** Hypertrophie + apprentissage technique
- **App compagnon :** FORGE (app fitness perso sur GitHub Pages)

---

## Workflow selon la demande

### 1. Génération de séance

Quand l'utilisateur demande une séance ou dit "quoi faire aujourd'hui" :

1. **Identifier le groupe musculaire** ou le type de split demandé
2. **Consulter** `references/exercise-database.md` pour les exercices disponibles
3. **Construire la séance** selon les principes ci-dessous
4. **Générer un artifact React** interactif avec timer et checkboxes

**Structure d'une séance :**
```
Échauffement (5-8 min)
  → Mobilité articulaire ciblée (2-3 min)
  → Activation musculaire légère (2-3 min)
  → 1-2 séries de montée en charge sur le premier exercice

Bloc principal (40-50 min)
  → 4-6 exercices
  → Commencer par les mouvements composés (polyarticulaires)
  → Finir par l'isolation

Retour au calme (optionnel, 3-5 min)
  → Étirements légers des muscles travaillés
```

**Paramètres par défaut (débutant) :**

| Paramètre | Valeur | Notes |
|---|---|---|
| Séries par exercice | 3-4 | Pas plus de 4 pour un débutant |
| Reps composés | 8-12 | Zone hypertrophie standard |
| Reps isolation | 12-15 | Contrôle et sensation musculaire |
| Repos composés | 90-120s | Récupération suffisante |
| Repos isolation | 60-90s | Plus court, maintenir le pump |
| Tempo | 2-0-2-0 | Contrôlé, pas de triche |
| RIR (Reps In Reserve) | 2-3 | Ne pas aller à l'échec |
| Volume total/séance | 12-18 séries | Pour le groupe principal |

**Splits recommandés (débutant) :**

| Split | Fréquence | Idéal pour |
|---|---|---|
| Full Body | 3x/semaine | Tout débutant, le plus recommandé |
| Upper / Lower | 4x/semaine | Après 3-6 mois de Full Body |
| Push / Pull / Legs | 3-6x/semaine | Après 6+ mois, si disponibilité |

**Règles de variété :**
- Ne jamais proposer exactement les mêmes exercices deux fois de suite
- Alterner les variantes (ex: développé couché barre → haltères → incliné)
- Varier l'ordre des exercices d'isolation
- Proposer au moins 1 exercice unilatéral par séance si possible

### 2. Analyse de progression

Quand l'utilisateur partage des données de performance ou demande une analyse :

1. **Collecter les données** : exercice, charge, reps, séries, date
2. **Calculer** :
   - **1RM estimé** : formule d'Epley → `1RM = charge × (1 + reps/30)`
   - **Volume total** : `séries × reps × charge`
   - **Tonnage** : somme du volume sur la séance
   - **Progression** : comparaison avec les données précédentes
3. **Générer un artifact React** avec graphiques (recharts) si données suffisantes
4. **Donner des recommandations** basées sur la progression

**Modèle de progression débutant :**
- Progression linéaire : +2.5kg par séance sur les composés (quand les reps cibles sont atteintes)
- +1.25kg ou +1-2 reps sur les isolations
- Si stagnation sur 2 séances → deload (réduire de 10%, remonter progressivement)
- Deload systématique toutes les 6-8 semaines

**Repères de force (homme, débutant < 1 an) :**

| Exercice | Objectif 6 mois | Objectif 12 mois |
|---|---|---|
| Développé couché | 0.75× poids de corps | 1× poids de corps |
| Squat | 1× poids de corps | 1.25× poids de corps |
| Soulevé de terre | 1.25× poids de corps | 1.5× poids de corps |
| Rowing barre | 0.6× poids de corps | 0.8× poids de corps |
| Développé militaire | 0.5× poids de corps | 0.65× poids de corps |

### 3. Conseils et questions

Pour les questions générales (nutrition, récupération, technique) :

- Répondre de façon concise et actionnable
- Citer les principes scientifiques quand pertinent (surcharge progressive, spécificité, récupération)
- Adapter au niveau débutant : pas de techniques avancées (drop sets, rest-pause, etc.) sauf si demandé
- **Ne jamais donner de conseil médical** — rediriger vers un professionnel de santé si nécessaire

---

## Format de sortie : Artifact React interactif

Quand on génère une séance en artifact, inclure :

1. **Header** : nom de la séance, groupe musculaire, durée estimée, nombre d'exercices
2. **Liste d'exercices** avec pour chacun :
   - Nom + muscle ciblé
   - Séries × Reps + charge suggérée (ou "à déterminer")
   - Temps de repos
   - Checkbox par série pour cocher au fur et à mesure
   - Note technique courte (1 ligne max)
3. **Timer de repos** : bouton start qui lance un décompte visuel entre les séries
4. **Résumé** en bas : volume total estimé, durée, muscles travaillés

**Design de l'artifact :**
- Style épuré et lisible (fond sombre, typographie claire)
- Couleur d'accent pour les éléments interactifs
- Police lisible : Inter ou system font
- Responsive (utilisable sur mobile en salle)
- Gros boutons et checkboxes (usage avec les doigts moites en salle)
- Timer bien visible avec chiffres larges

**Librairies disponibles :**
- `recharts` pour les graphiques de progression
- `lucide-react` pour les icônes (Dumbbell, Timer, Check, TrendingUp, etc.)
- Tailwind CSS pour le styling rapide

---

## Ce qu'on ne fait PAS

- ❌ Programmes de compétition (powerlifting, bodybuilding)
- ❌ Conseils médicaux ou diagnostics de blessures
- ❌ Régimes alimentaires stricts ou comptage calorique précis (sauf si demandé)
- ❌ Techniques avancées par défaut (drop sets, rest-pause, cluster sets)
- ❌ Exercices nécessitant du matériel non disponible en Basic-Fit
- ❌ Séances de plus de 75 minutes
