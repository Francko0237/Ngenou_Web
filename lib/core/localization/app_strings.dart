import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_language.dart';

class AppStrings {
  final AppLanguage language;
  const AppStrings(this.language);

  bool get isFr => language == AppLanguage.fr;

  // ---------------------------------------------------------------------------
  // Global / App
  // ---------------------------------------------------------------------------
  String get appTitle => isFr
      ? 'Ngenou — Votre Tuteur IA d\'Apprentissage Intelligent'
      : 'Ngenou — Your AI Smart Learning Tutor';

  // ---------------------------------------------------------------------------
  // Navigation Bar
  // ---------------------------------------------------------------------------
  String get navOverview => isFr ? 'Aperçu' : 'Overview';
  String get navFeatures => isFr ? 'Fonctionnalités' : 'Features';
  String get navWhatsNew => isFr ? 'Nouveautés' : 'What\'s New';
  String get navFaq => 'FAQ';
  String get navPrivacy => isFr ? 'Confidentialité & CGU' : 'Privacy & Terms';
  String get navNavigationTitle => isFr ? 'Navigation' : 'Navigation';
  String get navAppPreview => isFr ? 'Aperçu de l\'application' : 'App Preview';
  String get navWhatsNewUpdates =>
      isFr ? 'Nouveautés & Mises à jour' : 'Updates & What\'s New';

  // ---------------------------------------------------------------------------
  // Download Button & Messages
  // ---------------------------------------------------------------------------
  String get download => isFr ? 'Télécharger' : 'Download';
  String get downloadApk => isFr ? 'Télécharger l\'APK' : 'Download APK';
  String get downloadStartedSuccess =>
      isFr ? 'Téléchargement lancé avec succès !' : 'Download started successfully!';
  String get downloadFailed => isFr
      ? 'Impossible de démarrer le téléchargement.'
      : 'Unable to start download.';
  String get downloadError =>
      isFr ? 'Erreur lors du téléchargement.' : 'Error during download.';
  String get versionLabel => isFr ? 'Version' : 'Version';
  String get directDownload => isFr ? 'Téléchargement direct' : 'Direct Download';

  // ---------------------------------------------------------------------------
  // Hero Section
  // ---------------------------------------------------------------------------
  String get heroBadge => isFr
      ? 'Tuteur IA disponible maintenant'
      : 'AI Tutor available now';
  String get heroTitlePart1 =>
      isFr ? 'L\'apprentissage\nintelligent dont ' : 'Smart learning\nwhere ';
  String get heroTitleGradient =>
      isFr ? 'vous êtes le maître' : 'you are in control';
  String get heroTitlePart2 => '.';
  String get heroDesc => isFr
      ? 'Ngenou est un tuteur IA qui vous pose les bonnes questions au lieu de tout résoudre à votre place. Vos cours, votre planning et vos tâches restent accessibles sans connexion.'
      : 'Ngenou is an AI tutor that asks the right questions instead of doing everything for you. Your courses, schedule, and tasks remain accessible offline.';
  String get heroExploreButton =>
      isFr ? 'Voir l\'application' : 'Explore the app';
  String get heroSpecOffline =>
      isFr ? 'Cours et planning hors-ligne' : 'Offline courses & schedule';
  String get heroSpecLevels =>
      isFr ? 'Du primaire au supérieur' : 'From primary to higher ed';
  String get heroSpecSecurity =>
      isFr ? 'Données sauvegardées en sécurité' : 'Securely backed up data';

  // ---------------------------------------------------------------------------
  // Showcase Section
  // ---------------------------------------------------------------------------
  String get showcaseTitle => isFr
      ? 'Quatre outils, une seule application.'
      : 'Four tools, one single application.';
  String get showcaseSubtitle => isFr
      ? 'Choisissez un module pour voir comment il se présente sur votre téléphone.'
      : 'Select a module to preview how it looks on your phone.';

  // Showcase Tabs
  String get tabTutorTitle =>
      isFr ? 'Tuteur IA conversationnel' : 'Conversational AI Tutor';
  String get tabTutorDesc => isFr
      ? 'Le tuteur décompose vos exercices de maths, physique et informatique et vous guide pas à pas jusqu\'à comprendre le raisonnement par vous-même.'
      : 'The tutor breaks down your exercises in math, physics, and computer science, guiding you step-by-step until you master the reasoning on your own.';
  String get tabTutorFeat1 => isFr
      ? 'Dictée vocale pour poser vos questions à l\'oral'
      : 'Voice dictation to ask questions aloud';
  String get tabTutorFeat2 => isFr
      ? 'Synthèse vocale pour écouter les explications'
      : 'Text-to-speech to listen to explanations';
  String get tabTutorFeat3 => isFr
      ? 'Quiz rapides et historique des discussions sauvegardé'
      : 'Quick quizzes and saved chat history';
  String get tabTutorFeat4 => isFr
      ? 'Nécessite une connexion Internet'
      : 'Requires an active Internet connection';
  String get tabTutorCaption => isFr
      ? 'Ngenou Assistant en dialogue interactif avec cours structuré'
      : 'Ngenou Assistant in interactive dialogue with structured courses';

  String get tabDefisTitle =>
      isFr ? 'Défis quotidiens et quiz' : 'Daily Challenges & Quizzes';
  String get tabDefisDesc => isFr
      ? 'Chaque jour, des QCM ciblés sur vos matières pour entretenir votre série de jours consécutifs et débloquer des trophées.'
      : 'Targeted multiple choice quizzes across your subjects every day to keep your streak going and unlock trophies.';
  String get tabDefisFeat1 => isFr
      ? 'Série de jours pour garder le rythme'
      : 'Daily streaks to maintain consistent momentum';
  String get tabDefisFeat2 => isFr
      ? 'QCM interactifs avec explication immédiate'
      : 'Interactive MCQs with instant answer feedback';
  String get tabDefisFeat3 => isFr
      ? 'Badges et points d\'expérience (XP)'
      : 'Achievement badges and experience points (XP)';
  String get tabDefisCaption => isFr
      ? 'Défi du jour : QCM interactif avec score et correction immédiate'
      : 'Daily challenge: Interactive quiz with score & instant corrections';

  String get tabAssetsTitle =>
      isFr ? 'Extensions Ngenou Assets' : 'Ngenou Assets Extensions';
  String get tabAssetsDesc => isFr
      ? 'Ngenou Assets est le catalogue d\'extensions de l\'application : installez uniquement les outils pédagogiques dont vous avez besoin, et retirez-les quand vous n\'en avez plus l\'usage.'
      : 'Ngenou Assets is the in-app extension store: install only the learning tools you need, and remove them whenever you want.';
  String get tabAssetsFeat1 => isFr
      ? 'Extensions légères, à installer ou désinstaller à la demande'
      : 'Lightweight extensions, install or uninstall on demand';
  String get tabAssetsFeat2 => isFr
      ? 'Des outils pour le primaire, le secondaire et le supérieur'
      : 'Dedicated tools for primary, secondary, and higher ed';
  String get tabAssetsFeat3 => isFr
      ? 'Classées par catégorie : outils de développement, sciences et maths'
      : 'Categorized: Development tools, STEM, sciences & mathematics';
  String get tabAssetsCaption => isFr
      ? 'Catalogue d\'extensions légères installables en un clic'
      : 'Catalog of lightweight modular extensions installable in one click';

  String get tabPlanningTitle =>
      isFr ? 'Emploi du temps, alarmes et tâches' : 'Timetable, Alarms & Tasks';
  String get tabPlanningDesc => isFr
      ? 'Organisez vos révisions semaine par semaine, cochez vos tâches et recevez un rappel au bon moment.'
      : 'Organize your weekly revisions, mark tasks off, and receive study alarms right on schedule.';
  String get tabPlanningFeat1 => isFr
      ? 'Planning en grille de 7 jours, lisible d\'un coup d\'œil'
      : '7-day timetable grid, clear and easy to read at a glance';
  String get tabPlanningFeat2 => isFr
      ? 'Alarmes et notifications d\'étude à l\'heure prévue'
      : 'Study alarms and notifications at the scheduled hour';
  String get tabPlanningFeat3 => isFr
      ? 'Export et impression en PDF en un clic'
      : 'One-click PDF timetable export & printing';
  String get tabPlanningCaption => isFr
      ? 'Emploi du temps hebdomadaire & gestion des alarmes'
      : 'Weekly study timetable & alarm scheduling';

  // ---------------------------------------------------------------------------
  // Bento Features Section
  // ---------------------------------------------------------------------------
  String get bentoHeaderTitle => isFr
      ? 'Pensé pour réviser partout,\nmême quand le réseau lâche.'
      : 'Designed to study anywhere,\neven when connection drops.';
  String get bentoHeaderSubtitle => isFr
      ? 'Vos cours et votre planning vous suivent partout. Le tuteur vous rejoint dès que vous êtes en ligne.'
      : 'Your courses and timetable follow you everywhere. The AI tutor joins in as soon as you are online.';

  String get bento1Title =>
      isFr ? 'Vos cours restent avec vous' : 'Your courses stay with you';
  String get bento1Body => isFr
      ? 'Cours, synthèses, planning et tâches sont enregistrés sur votre téléphone. Révisez dans le bus ou en coupure de réseau : seul le tuteur IA a besoin d\'une connexion.'
      : 'Courses, summaries, timetable, and tasks are saved directly on your phone. Revise on the bus or during power outages: only the AI tutor requires internet.';
  String get bentoSyncPhone => isFr ? 'Téléphone' : 'Phone';
  String get bentoSyncAccount => isFr ? 'Compte sécurisé' : 'Secure Account';
  String get bentoSyncTag => 'sync';

  String get bento2Title =>
      isFr ? 'Vos données restent les vôtres' : 'Your data remains yours';
  String get bento2Body => isFr
      ? 'Dès que vous êtes en ligne, vos données sont sauvegardées de façon chiffrée et rattachées à votre seul compte. Vous pouvez les supprimer à tout moment.'
      : 'Whenever you are online, your data is securely encrypted and backed up to your personal account. You can delete it at any time.';
  String get bentoSecurityBadge => isFr
      ? 'Chiffrement & respect strict de vos données'
      : 'End-to-end encryption & strict privacy';

  String get bento3Title =>
      isFr ? 'Il questionne, vous trouvez' : 'It questions, you discover';
  String get bento3Body => isFr
      ? 'Le tuteur ne fait pas vos devoirs : il pose les questions qui font venir le déclic.'
      : 'The tutor doesn\'t do your homework for you: it asks the questions that spark genuine understanding.';
  String get bento3Quote => isFr
      ? '« C\'est en se trompant qu\'on apprend ! »'
      : '“We learn by making mistakes!”';

  String get bento4Title => isFr
      ? 'Une interface claire, des premiers pas guidés'
      : 'A clean interface, guided first steps';
  String get bento4Body => isFr
      ? 'Mode sombre, badges de progression et bulles d\'aide que vous pouvez relancer à tout moment pour découvrir l\'application sans stress.'
      : 'Dark mode, progress badges, and interactive tooltips you can relaunch anytime to explore the app without stress.';

  // ---------------------------------------------------------------------------
  // Download CTA Section
  // ---------------------------------------------------------------------------
  String get ctaTitle => isFr
      ? 'Gardez vos révisions\ndans votre poche.'
      : 'Keep your study sessions\nin your pocket.';
  String get ctaSubtitle => isFr
      ? 'Créez votre profil, choisissez votre niveau et lancez votre premier quiz en quelques minutes.'
      : 'Create your profile, select your level, and start your first quiz in just minutes.';

  // ---------------------------------------------------------------------------
  // FAQ Section
  // ---------------------------------------------------------------------------
  String get faqTitle =>
      isFr ? 'Questions fréquentes' : 'Frequently Asked Questions';
  String get faqContactPrefix =>
      isFr ? 'Une autre question ? Écrivez-nous à ' : 'Have another question? Email us at ';

  String get faq1Question => isFr
      ? 'Puis-je utiliser Ngenou sans connexion Internet ?'
      : 'Can I use Ngenou without an Internet connection?';
  String get faq1Answer => isFr
      ? 'En grande partie. Vos fiches de cours, vos extensions installées, votre planning et vos tâches restent accessibles sans connexion. Seul le tuteur IA a besoin d\'Internet. Dès que vous retrouvez du réseau, vos données sont sauvegardées automatiquement.'
      : 'For the most part, yes. Your study sheets, installed extensions, timetable, and tasks remain fully accessible offline. Only the AI tutor requires an Internet connection. Once reconnected, your data syncs automatically.';

  String get faq2Question => isFr
      ? 'Comment sont traitées mes questions posées au tuteur IA ?'
      : 'How are my questions to the AI tutor handled?';
  String get faq2Answer => isFr
      ? 'Vos questions sont envoyées de façon sécurisée à nos modèles pédagogiques, ce qui demande une connexion Internet. Vos échanges ne sont jamais utilisés pour entraîner des modèles publics et vous pouvez effacer votre historique de discussion à tout instant.'
      : 'Your questions are securely sent to our educational models. Your conversations are never used to train public AI models, and you can clear your chat history at any moment.';

  String get faq3Question => isFr
      ? 'Comment puis-je supprimer définitivement mon compte et mes données ?'
      : 'How can I permanently delete my account and data?';
  String get faq3Answer => isFr
      ? 'Un bouton « Supprimer définitivement mon compte » est disponible dans les Paramètres de l\'application. Il efface immédiatement vos données sur votre téléphone ainsi que toutes vos données sauvegardées en ligne.'
      : 'A "Permanently delete my account" button is available in the app settings. It immediately purges your local device data and all associated cloud backups.';

  String get faq4Question => isFr
      ? 'Quels niveaux scolaires sont pris en charge ?'
      : 'Which education levels are supported?';
  String get faq4Answer => isFr
      ? 'Ngenou s\'adapte au niveau défini dans votre profil : primaire, secondaire (collège et lycée) et enseignement supérieur / universitaire. Le ton, les exemples et la profondeur des explications du tuteur sont automatiquement ajustés.'
      : 'Ngenou tailors itself to the level chosen in your profile: primary school, secondary/high school, and higher/university education. The AI tutor\'s tone, examples, and depth of explanation adapt automatically.';

  // ---------------------------------------------------------------------------
  // Footer
  // ---------------------------------------------------------------------------
  String get footerBrandDesc => isFr
      ? 'L\'application d\'apprentissage intelligent qui allie tuteur IA personnalisé, extensions pédagogiques et suivi de révision.'
      : 'The smart learning app combining a personalized AI tutor, educational extensions, and revision tracking.';
  String get footerColLegal =>
      isFr ? 'Légal & Conformité' : 'Legal & Compliance';
  String get footerColDev =>
      isFr ? 'Développeur & Support' : 'Developer & Support';
  String get footerPrivacy =>
      isFr ? 'Politique de Confidentialité' : 'Privacy Policy';
  String get footerTerms =>
      isFr ? 'Conditions d\'Utilisation (CGU)' : 'Terms of Service (ToS)';
  String get footerAccountDeletion =>
      isFr ? 'Suppression de compte' : 'Account Deletion';
  String get footerCopyright =>
      isFr ? '© 2026 Ngenou. Tous droits réservés.' : '© 2026 Ngenou. All rights reserved.';
  String get footerTagline =>
      isFr ? 'Conçu pour l\'excellence académique.' : 'Engineered for academic excellence.';
  String get footerAuthor =>
      isFr ? 'Par Yamga Mokube Franck Daniel' : 'By Yamga Mokube Franck Daniel';

  // ---------------------------------------------------------------------------
  // Nouveautes Page (/nouveautes)
  // ---------------------------------------------------------------------------
  String get changelogBadge =>
      isFr ? 'Changelog & Historique' : 'Changelog & Releases';
  String get changelogTitle =>
      isFr ? 'Toutes les nouveautés de Ngenou' : 'All Ngenou Releases & Updates';
  String get changelogSubtitle => isFr
      ? 'Découvrez au fil des mises à jour les nouvelles fonctionnalités pédagogiques et améliorations apportées à l\'application.'
      : 'Discover the latest educational features and system improvements introduced with each update.';
  String get filterAll => isFr ? 'Toutes' : 'All';
  String get filterStable => isFr ? 'Stables' : 'Stable';
  String get filterBeta => isFr ? 'Bêtas' : 'Betas';
  String get latestBadge => isFr ? 'Dernière version' : 'Latest Release';
  String get emptyReleasesTitle =>
      isFr ? 'Aucune version publiée' : 'No releases published yet';
  String get emptyReleasesDesc => isFr
      ? 'Revenez bientôt pour découvrir les prochaines mises à jour.'
      : 'Check back soon to discover upcoming updates.';
  String get releaseNotes => isFr ? 'Notes de version :' : 'Release notes:';
  String get releaseMinAndroid =>
      isFr ? 'Android 5.0 minimum (API 21)' : 'Android 5.0 minimum (API 21)';
  String get releaseApkSize => isFr ? 'Taille APK' : 'APK Size';

  // ---------------------------------------------------------------------------
  // Confidentialite Page (/confidentialite)
  // ---------------------------------------------------------------------------
  String get legalPageTitle => isFr
      ? 'Politique de confidentialité et CGU'
      : 'Privacy Policy & Terms of Service';
  String get legalPageSubtitle => isFr
      ? 'Dernière mise à jour : 28 octobre 2026. Application Ngenou, version 1.1.'
      : 'Last updated: October 28, 2026. Ngenou Application, version 1.1.';
  String get legalSideSummary => isFr ? 'Sommaire' : 'Summary';
  String get legalSection1Nav =>
      isFr ? '1. Politique de confidentialité' : '1. Privacy Policy';
  String get legalSection2Nav =>
      isFr ? '2. Collecte & Usage des données' : '2. Data Collection & Usage';
  String get legalSection3Nav =>
      isFr ? '3. Stockage local & Sécurité' : '3. Local Storage & Security';
  String get legalSection4Nav =>
      isFr ? '4. Suppression & Droits utilisateur' : '4. Deletion & User Rights';
  String get legalSection5Nav =>
      isFr ? '5. Conditions d\'utilisation' : '5. Terms of Service';

  String get legalContactUs =>
      isFr ? 'Une question sur vos données ?' : 'A question about your data?';
  String get legalWriteToSupport =>
      isFr ? 'Écrire au délégué à la protection des données :' : 'Contact data protection support:';
}

final appStringsProvider = Provider<AppStrings>((ref) {
  final lang = ref.watch(appLanguageProvider);
  return AppStrings(lang);
});
