# Design System — Portfolio Classique Élégant

## Palette de couleurs

### Mode sombre (par défaut)
```css
--bg-primary: #0f1117;        /* Fond principal — noir profond neutre */
--bg-secondary: #161920;      /* Fond cards/sections */
--bg-tertiary: #1e2028;       /* Fond éléments surélevés */
--bg-subtle: #252830;         /* Fond hover, inputs */

--text-primary: #f0f0f3;      /* Texte principal — blanc doux */
--text-secondary: #9ca3b0;    /* Texte secondaire */
--text-muted: #5c6370;        /* Labels, captions */

--border: rgba(255,255,255,0.07);  /* Bordures subtiles */
--border-hover: rgba(255,255,255,0.12);
```

### Accents
```css
--accent: #6366f1;            /* Indigo — accent principal */
--accent-light: #818cf8;      /* Indigo clair — hover */
--accent-soft: rgba(99,102,241,0.12); /* Fond accent */

--success: #34d399;           /* Vert doux */
--warning: #fbbf24;           /* Ambre */
--info: #60a5fa;              /* Bleu ciel */
```

### Mode clair (alternatif)
```css
--bg-primary: #ffffff;
--bg-secondary: #f8f9fb;
--bg-tertiary: #f0f1f4;
--text-primary: #1a1a2e;
--text-secondary: #6b7280;
--border: rgba(0,0,0,0.08);
--accent: #4f46e5;
```

## Typographie

### Fonts recommandées (Google Fonts)
```
Titres :         "Inter", weight 700 / 800
Sous-titres :    "Inter", weight 600
Corps :          "Inter", weight 400 / 500
Mono/technique : "JetBrains Mono", weight 400
```

Alternative élégante :
```
Titres :         "Plus Jakarta Sans", weight 700 / 800
Corps :          "Plus Jakarta Sans", weight 400 / 500
```

### Hiérarchie
```css
--font-display: 3rem / 1.1;    /* Titres hero — bold, tracking -0.02em */
--font-h1: 2rem / 1.2;         /* Titres sections */
--font-h2: 1.5rem / 1.3;       /* Sous-titres */
--font-h3: 1.125rem / 1.4;     /* Labels cartes */
--font-body: 0.9375rem / 1.7;  /* Corps — 15px */
--font-small: 0.8125rem / 1.5; /* Captions, badges */
--font-micro: 0.75rem / 1.4;   /* Tags, metadata */
```

## Espacements

```css
--radius-sm: 8px;
--radius-md: 12px;
--radius-lg: 16px;
--radius-xl: 24px;

--space-xs: 4px;
--space-sm: 8px;
--space-md: 16px;
--space-lg: 24px;
--space-xl: 48px;
--space-2xl: 80px;
```

## Ombres

```css
--shadow-sm: 0 1px 2px rgba(0,0,0,0.08);
--shadow-md: 0 4px 12px rgba(0,0,0,0.12);
--shadow-lg: 0 8px 30px rgba(0,0,0,0.16);
--shadow-xl: 0 16px 50px rgba(0,0,0,0.2);

/* Ombre accent (pour les éléments interactifs au hover) */
--shadow-accent: 0 8px 30px rgba(99,102,241,0.15);
```

## Animations

### Timing functions
```css
--ease-smooth: cubic-bezier(0.4, 0, 0.2, 1);      /* Standard */
--ease-decelerate: cubic-bezier(0, 0, 0.2, 1);     /* Entrées */
--ease-spring: cubic-bezier(0.34, 1.56, 0.64, 1);  /* Rebond subtil */
```

### Patterns d'animation
```
Reveal section :     translateY(32px) → 0, opacity 0 → 1, 0.7s, ease-decelerate
Stagger children :   delay 0.06s entre chaque enfant
Hover card :         translateY(-4px), shadow-lg → shadow-accent, 0.3s ease-smooth
Hover bouton :       scale(1.02), brightness(1.1), 0.2s
Focus ring :         box-shadow 0 0 0 3px var(--accent-soft), 0.15s
Counter/nombre :     animation de comptage smooth (ex: 0 → 85 en 1.2s)
Progress bar :       width 0% → N%, 1s ease-decelerate avec delay staggeré
```

### Transitions recommandées
```css
/* Pour les cartes et éléments interactifs */
transition: all 0.3s var(--ease-smooth);

/* Pour les reveals au scroll */
transition: opacity 0.7s var(--ease-decelerate), 
            transform 0.7s var(--ease-decelerate);

/* Pour les micro-interactions (badges, icônes) */
transition: all 0.2s var(--ease-smooth);
```

## Composants visuels

### Carte
```
Fond : bg-secondary
Bordure : 1px solid var(--border)
Radius : radius-lg
Padding : space-lg
Hover : translateY(-4px), border-hover, shadow-accent
Transition : 0.3s ease-smooth
```

### Badge / Tag
```
Fond : accent-soft ou gris très léger
Texte : accent ou text-secondary
Radius : radius-sm
Padding : 4px 12px
Font : small, weight 500
```

### Séparateur
```
Ligne 1px, couleur border
Largeur 100% ou partielle centrée
Margin vertical : space-xl
```

### Bouton primaire
```
Fond : accent
Texte : blanc
Radius : radius-md
Padding : 10px 20px
Hover : accent-light + shadow-accent + scale(1.02)
```
