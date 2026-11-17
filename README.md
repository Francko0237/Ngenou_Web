<div align="center">

<img src="assets/images/logo_full.png" alt="Ngenou Logo" width="120" />

# Ngenou Web

**Site vitrine officiel et console d'administration de l'application mobile Ngenou**

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart)](https://dart.dev)
[![Supabase](https://img.shields.io/badge/Supabase-Backend-3ECF8E?logo=supabase)](https://supabase.com)
[![Vercel](https://img.shields.io/badge/Vercel-Déployé-000000?logo=vercel)](https://ngenou.vercel.app)
[![Licence](https://img.shields.io/badge/Licence-Propriétaire-red)](LICENSE)

🌐 **Site en production** : [ngenou.vercel.app](https://ngenou.vercel.app)

</div>

---

## À propos de Ngenou

**Ngenou** est une application mobile d'apprentissage intelligent conçue pour les élèves et étudiants francophones. Elle propose :

- 🤖 **Tuteur IA conversationnel** — Guide pas à pas en maths, physique et informatique, avec dictée vocale et synthèse audio
- 🏆 **Défis quotidiens et quiz** — Séries de jours consécutifs, QCM avec correction immédiate et badges XP
- 🧩 **Ngenou Assets** — Catalogue d'extensions pédagogiques légères installables à la demande
- 📅 **Emploi du temps & alarmes** — Planning hebdomadaire, rappels d'étude, export PDF
- 📶 **Mode hors-ligne** — Cours, extensions installées, planning et tâches disponibles sans connexion Internet

Ce dépôt contient le **site vitrine Flutter Web** et la **console d'administration** utilisés pour publier les mises à jour de l'APK.

---

## Fonctionnalités du Site

| Section | Route | Accès |
|---|---|---|
| Page d'accueil | `/` | Public |
| Nouveautés & historique des versions | `/nouveautes` | Public |
| Politique de confidentialité | `/confidentialite` | Public |
| Console d'administration | `/admin` | 🔒 Admin authentifié |
| Connexion admin | `/admin/login` | 🔒 Admin |
| Formulaire de version | `/admin/releases/new` | 🔒 Admin |
| Édition d'une version | `/admin/releases/:id/edit` | 🔒 Admin |

---

## Stack Technique

```
Flutter Web 3.x + Dart 3.x
├── go_router           → Routage URL propre (sans #), gardes d'accès admin
├── flutter_riverpod    → Gestion d'état globale
├── supabase_flutter    → Auth, PostgreSQL (RLS), Storage
├── google_fonts        → Fraunces (titres) + Manrope (corps)
├── flutter_animate     → Animations d'entrée fluides
├── url_launcher        → Liens externes (téléchargement APK)
├── file_picker         → Upload images dans la console admin
└── cached_network_image → Chargement optimisé des images Supabase
```

**Déploiement** : Vercel (SPA Flutter Web, build statique `build/web`)  
**Base de données** : Supabase PostgreSQL avec Row Level Security (RLS)

---

## Design System

| Élément | Valeur |
|---|---|
| Fond principal | `#060B1A` |
| Cartes | `#0F1A33` |
| Couleur Cyan | `#3CC8E8` |
| Couleur Or | `#F0B93A` |
| Texte principal | `#F3EEE2` |
| Texte secondaire | `#9BA8C4` |
| Dégradé signature | Cyan `#3CC8E8` → Or `#F0B93A` |
| Titre principal | **Fraunces** (Google Fonts) |
| Corps & UI | **Manrope** (Google Fonts) |

---

## Structure du Projet

```
ngenou_web/
├── assets/
│   ├── images/                   # logo.png, logo_full.png
│   └── screenshots/              # Captures d'écran de l'app mobile
├── lib/
│   ├── core/
│   │   ├── models/               # AppRelease, ReleaseFeature
│   │   ├── supabase/             # SupabaseConfig, ReleaseRepository,
│   │   │                         # AuthRepository, Providers Riverpod
│   │   ├── theme/                # AppColors, AppTheme
│   │   └── widgets/              # SiteNavbar, SiteFooter, PhoneMockup,
│   │                             # DualPhoneMockup, DownloadButton, Responsive
│   ├── features/
│   │   ├── public/
│   │   │   ├── home/             # Hero, Showcase tabs, Bento grid, CTA, FAQ
│   │   │   ├── nouveautes/       # Historique des versions publiées
│   │   │   └── confidentialite/  # Politique de confidentialité & CGU
│   │   └── admin/
│   │       ├── auth/             # Connexion admin + protection anti-bruteforce
│   │       ├── dashboard/        # Liste versions, recherche, tri, publication
│   │       └── release_form/     # Création/édition version, upload APK & images
│   ├── routes/                   # GoRouter avec gardes admin
│   └── main.dart
├── mobile_integration/           # Code prêt à intégrer dans l'app mobile
│   ├── update_checker_service.dart
│   ├── update_dialog.dart
│   └── parametres_update_tile.dart
├── web/
│   ├── index.html                # HTML principal, preload des assets critiques
│   ├── robots.txt                # Disallow: /admin
│   ├── sitemap.xml               # Sitemap public
│   └── favicon.png
├── build/web/                    # Build de production Flutter Web (commité)
│   └── vercel.json               # Config SPA routing Vercel
├── supabase_migration.sql        # Migration SQL complète (tables + RLS + buckets)
├── vercel.json                   # Config Vercel racine
└── pubspec.yaml
```

---

## Installation & Développement Local

### Prérequis

- Flutter SDK `>=3.0.0` ([installer Flutter](https://flutter.dev/docs/get-started/install))
- Un projet Supabase configuré (voir section [Configuration Supabase](#configuration-supabase))
- Un navigateur Chrome/Chromium

### 1. Cloner et installer les dépendances

```bash
git clone https://github.com/Francko0237/Ngenou_Web.git
cd Ngenou_Web
flutter pub get
```

### 2. Lancer en développement

```bash
flutter run -d chrome \
  --dart-define=SUPABASE_URL=https://votre-projet.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=votre_cle_anon_publique
```

> **Clés par défaut** : Le projet contient des clés Supabase de développement codées en dur dans `supabase_config.dart`. Vous pouvez les utiliser directement pour tester sans les `--dart-define`.

### 3. Compiler pour la production

```bash
flutter build web --release \
  --dart-define=SUPABASE_URL=https://votre-projet.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=votre_cle_anon_publique
```

Les fichiers générés se trouvent dans `build/web/`.

> ⚠️ **Sécurité** : N'utilisez **jamais** la clé `service_role` dans le client web. Seule la clé `anon` (publique) doit être exposée côté client.

---

## Configuration Supabase

### 1. Exécuter la migration SQL

Dans le **SQL Editor** de votre tableau de bord Supabase, exécutez le contenu du fichier [`supabase_migration.sql`](supabase_migration.sql).

Ce script crée :
- Les tables `app_releases`, `release_features`, `profiles`
- Les politiques **Row Level Security (RLS)** :
  - Lecture publique des versions `is_published = true` uniquement
  - Écriture (création, modification, suppression) réservée aux admins
- Les buckets de stockage `release-media` et `apks`
- Un jeu de données initial (version 1.1.0)

### 2. Désactiver l'inscription publique

Dans Supabase → **Authentication > Configuration > Sign Up**  
→ Décochez **« Allow new users to sign up »**

### 3. Créer le premier administrateur

```sql
-- 1. Créer l'utilisateur dans Authentication > Users > Add user
-- 2. Récupérer son UUID, puis exécuter dans le SQL Editor :

UPDATE public.profiles
SET role = 'admin'
WHERE id = 'VOTRE_UUID_UTILISATEUR';
```

---

## Déploiement sur Vercel

Le projet est configuré pour être déployé **en tant que site statique** depuis le dossier `build/web/`.

### Option A — Déploiement automatique via GitHub (recommandé)

1. Connecter le dépôt GitHub à [Vercel](https://vercel.com/new)
2. Dans **Build & Output Settings** :
   - **Framework Preset** : `Other`
   - **Build Command** : *(laisser vide — le build Flutter est commité)*
   - **Output Directory** : `build/web`
3. Cliquer sur **Deploy**

### Option B — Déploiement manuel avec la CLI

```bash
# Installer Vercel CLI
npm i -g vercel

# Builder localement
flutter build web --release

# Déployer le répertoire de sortie
vercel build/web --prod
```

### Gestion du routing SPA

Le fichier `build/web/vercel.json` contient les règles de réécriture qui redirigent toutes les routes vers `index.html`, permettant à GoRouter de gérer la navigation côté client :

```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

---

## Intégration dans l'Application Mobile

Le dossier [`mobile_integration/`](mobile_integration/) contient les fichiers prêts à copier dans l'application mobile Flutter pour gérer les mises à jour automatiques.

### Vérification au démarrage (1 fois par jour)

```dart
// Dans votre main.dart ou écran principal :
import 'mobile_integration/update_checker_service.dart';

@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    UpdateChecker.checkOnStartup(context);
  });
}
```

### Widget dans les Paramètres

```dart
import 'mobile_integration/parametres_update_tile.dart';

// Dans votre ListView de paramètres :
const ParametresUpdateTile(
  currentVersionName: '1.1.0',
  currentVersionCode: 11,
),
```

### Comportement des mises à jour

| Type | Description |
|---|---|
| **Mise à jour standard** | Boîte de dialogue avec les nouveautés, bouton « Télécharger » et « Plus tard » |
| **Mise à jour obligatoire** (`force_update: true`) | Boîte de dialogue non-fermable, seul le téléchargement est disponible |

---

## Sécurité

| Mesure | Implémentation |
|---|---|
| **URL admin masquée** | Absent du sitemap, robots.txt, et de tous les liens publics |
| **Row Level Security** | Toutes les requêtes Supabase sont filtrées au niveau PostgreSQL |
| **Anti-bruteforce** | Verrouillage du formulaire de connexion après 5 tentatives échouées |
| **Noindex automatique** | Meta-tag `robots: noindex, nofollow` injecté sur `/admin/*` |
| **En-têtes HTTP** | `X-Content-Type-Options: nosniff`, `X-Frame-Options: DENY` |
| **Clé anon uniquement** | La clé `service_role` Supabase n'est jamais exposée côté client |

---

## Téléchargement de l'APK

La dernière version de l'application est disponible sur :  
👉 [ngenou.vercel.app](https://ngenou.vercel.app) → Bouton **Télécharger**

Les releases sont également disponibles sur [GitHub Releases](https://github.com/Francko0237/Ngenou_Web/releases).

---

## Contact & Support

- 📧 **Support** : ngenou.support@gmail.com
- 🌐 **Site officiel** : [ngenou.vercel.app](https://ngenou.vercel.app)
- 📱 **Application** : Android (APK direct — compatible 32-bit et 64-bit)

---

<div align="center">

**Ngenou** — *Votre tuteur IA d'apprentissage intelligent*

© 2024-2025 Ngenou. Tous droits réservés.

</div>
