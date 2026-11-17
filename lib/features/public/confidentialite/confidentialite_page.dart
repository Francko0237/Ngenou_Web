import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/site_footer.dart';
import '../../../core/widgets/site_navbar.dart';

/// Page légale : Politique de confidentialité & CGU (/confidentialite)
class ConfidentialitePage extends ConsumerStatefulWidget {
  const ConfidentialitePage({super.key});

  @override
  ConsumerState<ConfidentialitePage> createState() =>
      _ConfidentialitePageState();
}

class _ConfidentialitePageState extends ConsumerState<ConfidentialitePage> {
  final GlobalKey _privacyKey = GlobalKey();
  final GlobalKey _dataKey = GlobalKey();
  final GlobalKey _syncKey = GlobalKey();
  final GlobalKey _deletionKey = GlobalKey();
  final GlobalKey _cguKey = GlobalKey();

  int _activeSectionIndex = 0;

  void _scrollTo(GlobalKey key, int index) {
    setState(() => _activeSectionIndex = index);
    if (key.currentContext != null) {
      Scrollable.ensureVisible(
        key.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  Future<void> _openEmail() async {
    final uri = Uri.parse('mailto:ngenou.support@gmail.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);
    final strings = ref.watch(appStringsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const SiteNavbar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero légal
            Container(
              padding: EdgeInsets.symmetric(
                vertical: isMobile ? 40 : 64,
                horizontal: Responsive.horizontalPadding(context),
              ),
              decoration: const BoxDecoration(
                color: Color(0xFF070E20),
                border: Border(
                  bottom: BorderSide(color: AppColors.cardBorder, width: 1),
                ),
              ),
              child: ResponsiveContainer(
                child: Column(
                  children: [
                    Text(
                      strings.legalPageTitle,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.fraunces(
                        fontSize: isMobile ? 30 : 44,
                        fontWeight: FontWeight.w700,
                        color: AppColors.text,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      strings.legalPageSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Contenu principal avec sommaire
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 56),
              child: ResponsiveContainer(
                child: isDesktop
                    ? Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Sommaire latéral collant
                          SizedBox(
                            width: 280,
                            child: _buildSidebar(strings),
                          ),
                          const SizedBox(width: 48),
                          // Articles
                          Expanded(
                            child: _buildArticlesList(strings),
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _buildSidebarHorizontal(strings),
                          const SizedBox(height: 36),
                          _buildArticlesList(strings),
                        ],
                      ),
              ),
            ),

            const SiteFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildSidebar(AppStrings strings) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            strings.legalSideSummary.toUpperCase(),
            style: const TextStyle(
              color: AppColors.textMuted,
              fontWeight: FontWeight.w700,
              fontSize: 12,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 16),
          _TocButton(
            title: strings.isFr
                ? '1. Responsable du traitement'
                : '1. Data Controller',
            isActive: _activeSectionIndex == 0,
            onTap: () => _scrollTo(_privacyKey, 0),
          ),
          _TocButton(
            title: strings.isFr
                ? '2. Données collectées'
                : '2. Collected Data',
            isActive: _activeSectionIndex == 1,
            onTap: () => _scrollTo(_dataKey, 1),
          ),
          _TocButton(
            title: strings.isFr
                ? '3. Synchronisation & sécurité'
                : '3. Sync & Security',
            isActive: _activeSectionIndex == 2,
            onTap: () => _scrollTo(_syncKey, 2),
          ),
          _TocButton(
            title: strings.isFr
                ? '4. Suppression du compte'
                : '4. Account Deletion',
            isActive: _activeSectionIndex == 3,
            onTap: () => _scrollTo(_deletionKey, 3),
          ),
          _TocButton(
            title: strings.isFr
                ? '5. Conditions d\'utilisation'
                : '5. Terms of Service',
            isActive: _activeSectionIndex == 4,
            onTap: () => _scrollTo(_cguKey, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarHorizontal(AppStrings strings) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _TocChip(
            title: strings.isFr ? '1. Responsable' : '1. Controller',
            isActive: _activeSectionIndex == 0,
            onTap: () => _scrollTo(_privacyKey, 0),
          ),
          const SizedBox(width: 8),
          _TocChip(
            title: strings.isFr ? '2. Données' : '2. Data',
            isActive: _activeSectionIndex == 1,
            onTap: () => _scrollTo(_dataKey, 1),
          ),
          const SizedBox(width: 8),
          _TocChip(
            title: strings.isFr ? '3. Sécurité' : '3. Security',
            isActive: _activeSectionIndex == 2,
            onTap: () => _scrollTo(_syncKey, 2),
          ),
          const SizedBox(width: 8),
          _TocChip(
            title: strings.isFr ? '4. Suppression' : '4. Deletion',
            isActive: _activeSectionIndex == 3,
            onTap: () => _scrollTo(_deletionKey, 3),
          ),
          const SizedBox(width: 8),
          _TocChip(
            title: strings.isFr ? '5. CGU' : '5. Terms',
            isActive: _activeSectionIndex == 4,
            onTap: () => _scrollTo(_cguKey, 4),
          ),
        ],
      ),
    );
  }

  Widget _buildArticlesList(AppStrings strings) {
    final isFr = strings.isFr;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Article 1
        _LegalArticle(
          key: _privacyKey,
          icon: Icons.person_outline_rounded,
          accent: AppColors.cyan,
          number: '1',
          title: isFr
              ? 'Responsable du traitement des données'
              : 'Data Controller & Contact Information',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFr
                    ? 'L\'application mobile Ngenou est éditée par Yamga Mokube Franck Daniel.'
                    : 'The Ngenou mobile app is developed and published by Yamga Mokube Franck Daniel.',
                style: const TextStyle(color: AppColors.text, height: 1.6),
              ),
              const SizedBox(height: 12),
              Wrap(
                children: [
                  Text(
                    isFr
                        ? 'Pour toute question relative à la protection de votre vie privée ou pour exercer vos droits légaux (accès, rectification, suppression), vous pouvez nous contacter directement par courriel à : '
                        : 'For any inquiry regarding privacy or to exercise your rights (access, rectification, erasure), contact us directly at: ',
                    style: const TextStyle(color: AppColors.textMuted, height: 1.6),
                  ),
                  InkWell(
                    onTap: _openEmail,
                    child: const Text(
                      'ngenou.support@gmail.com',
                      style: TextStyle(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const Text('.', style: TextStyle(color: AppColors.textMuted)),
                ],
              ),
            ],
          ),
        ),

        // Article 2
        _LegalArticle(
          key: _dataKey,
          icon: Icons.storage_rounded,
          accent: AppColors.gold,
          number: '2',
          title: isFr
              ? 'Données collectées et finalités'
              : 'Collected Data & Purposes',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFr
                    ? 'Ngenou collecte et traite uniquement les données strictement nécessaires aux services d\'apprentissage :'
                    : 'Ngenou collects and processes only the data strictly required for educational features:',
                style: const TextStyle(color: AppColors.text, height: 1.6),
              ),
              const SizedBox(height: 14),
              _BulletPoint(
                title: isFr ? 'Données de compte : ' : 'Account data: ',
                body: isFr
                    ? 'Pseudonyme / nom choisi, adresse email (si connexion via email ou Google Sign-In) ou numéro de téléphone (utilisé sous forme d\'identifiant chiffré), rôle (élève, enseignant) et niveau scolaire (primaire, secondaire, supérieur).'
                    : 'Chosen username / name, email address (if authenticated via email or Google) or phone number (as an encrypted unique identifier), role (student, teacher) and grade/education level.',
              ),
              _BulletPoint(
                title: isFr ? 'Contenu éducatif : ' : 'Educational content: ',
                body: isFr
                    ? 'Cours personnalisés créés ou importés, défis quotidiens, scores aux quiz, fiches de révision et codes algorithmiques sauvegardés.'
                    : 'Personalized course notes, daily challenges, quiz scores, flashcards, and algorithm solutions.',
              ),
              _BulletPoint(
                title: isFr
                    ? 'Interactions avec le tuteur IA : '
                    : 'Interactions with the AI tutor: ',
                body: isFr
                    ? 'Les questions et prompts posés au tuteur sont traités pour délivrer des explications pédagogiques socratiques. Ces données restent privées et ne sont jamais vendues ni utilisées pour entraîner des modèles publics tiers.'
                    : 'Questions and prompts sent to the tutor are processed to deliver step-by-step Socratic explanations. This data is private, strictly confidential, and never used to train public third-party models.',
              ),
              _BulletPoint(
                title: isFr
                    ? 'Autorisations matérielles : '
                    : 'Device permissions: ',
                body: isFr
                    ? '• Microphone : Activé exclusivement à la demande de l\'utilisateur pour la saisie vocale (Speech-to-Text). Aucun flux audio continu n\'est enregistré.\n• Haut-parleur et audio : Pour la synthèse vocale (TTS) des cours et les alarmes d\'étude.\n• Stockage local : Base locale chiffrée permettant à l\'application de fonctionner sans connexion Internet.'
                    : '• Microphone: Activated solely upon explicit user request for speech-to-text dictation. No continuous audio stream is ever recorded.\n• Speaker/Audio: For text-to-speech audio explanations and study alarms.\n• Local storage: Encrypted local database allowing the app to run completely offline.',
              ),
            ],
          ),
        ),

        // Article 3
        _LegalArticle(
          key: _syncKey,
          icon: Icons.cloud_done_outlined,
          accent: AppColors.cyan,
          number: '3',
          title: isFr
              ? 'Synchronisation cloud et sécurité'
              : 'Cloud Synchronization & Security',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFr
                    ? 'Ngenou adopte une philosophie Offline-First :'
                    : 'Ngenou is built on an Offline-First philosophy:',
                style: const TextStyle(color: AppColors.text, height: 1.6),
              ),
              const SizedBox(height: 14),
              _BulletPoint(
                title: isFr
                    ? 'Stockage local prioritaire : '
                    : 'Local-first storage: ',
                body: isFr
                    ? 'Toutes vos données sont prioritairement stockées localement sur votre appareil dans une base de données chiffrée.'
                    : 'All study materials are stored locally on your device in an encrypted database for zero-latency offline access.',
              ),
              _BulletPoint(
                title: isFr
                    ? 'Chiffrement et sécurité : '
                    : 'End-to-end encryption & security: ',
                body: isFr
                    ? 'Lorsque vous disposez d\'une connexion Internet et d\'un compte actif, vos données sont synchronisées via notre infrastructure cloud sécurisée avec chiffrement TLS et politiques strictes d\'accès garantissant que seul votre compte a accès à vos données.'
                    : 'When online with an active account, your data syncs via encrypted TLS connections and strict row-level security policies ensuring only you have access to your data.',
              ),
            ],
          ),
        ),

        // Article 4
        _LegalArticle(
          key: _deletionKey,
          icon: Icons.delete_outline_rounded,
          accent: AppColors.gold,
          number: '4',
          title: isFr
              ? 'Droit à l\'effacement et suppression définitive du compte'
              : 'Right to Erasure & Permanent Account Deletion',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFr
                    ? 'Conformément aux directives de l\'Apple App Store (Guideline 5.1.1(v)), du Google Play Store et au RGPD :'
                    : 'In accordance with Apple App Store Guideline 5.1.1(v), Google Play policies, and GDPR requirements:',
                style: const TextStyle(color: AppColors.text, height: 1.6),
              ),
              const SizedBox(height: 14),
              Text(
                isFr
                    ? 'Chaque utilisateur peut à tout moment supprimer l\'intégralité de son compte et de ses données personnelles :'
                    : 'Every user may at any time permanently delete their entire account and all associated personal data:',
                style: const TextStyle(color: AppColors.textMuted, height: 1.6),
              ),
              const SizedBox(height: 12),
              _BulletPoint(
                title: isFr
                    ? 'Directement dans l\'application : '
                    : 'Directly in-app: ',
                body: isFr
                    ? 'Ouvrez l\'onglet Paramètres > Faites défiler jusqu\'en bas > Cliquez sur « Supprimer définitivement mon compte ».'
                    : 'Open the Settings tab > Scroll to the bottom > Tap "Permanently delete my account".',
              ),
              _BulletPoint(
                title: isFr
                    ? 'Effacement immédiat : '
                    : 'Immediate deletion: ',
                body: isFr
                    ? 'Cette action entraîne la suppression instantanée et irréversible de l\'ensemble de vos données locales et de tous vos enregistrements sur les serveurs distants.'
                    : 'This action triggers the immediate, irreversible deletion of all local storage and all remote cloud records.',
              ),
              Wrap(
                children: [
                  Text(
                    isFr
                        ? 'Vous pouvez également formuler une demande de suppression par email à '
                        : 'You can also request account deletion by emailing ',
                    style: const TextStyle(color: AppColors.textMuted, height: 1.6),
                  ),
                  InkWell(
                    onTap: _openEmail,
                    child: const Text(
                      'ngenou.support@gmail.com',
                      style: TextStyle(
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    isFr
                        ? '. Votre demande sera traitée sous 48 heures ouvrées.'
                        : '. Your request will be fulfilled within 48 business hours.',
                    style: const TextStyle(color: AppColors.textMuted, height: 1.6),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Article 5
        _LegalArticle(
          key: _cguKey,
          icon: Icons.description_outlined,
          accent: AppColors.cyan,
          number: '5',
          title: isFr
              ? 'Conditions Générales d\'Utilisation (CGU)'
              : 'Terms of Service (ToS)',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isFr
                    ? 'L\'utilisation de Ngenou implique l\'acceptation pleine et entière des présentes conditions :'
                    : 'Using Ngenou constitutes full acceptance of the following terms:',
                style: const TextStyle(color: AppColors.text, height: 1.6),
              ),
              const SizedBox(height: 14),
              _BulletPoint(
                title: isFr
                    ? 'Service d\'appoint éducatif : '
                    : 'Educational companion service: ',
                body: isFr
                    ? 'Le tuteur IA est un compagnon pédagogique destiné à faciliter la compréhension. Bien qu\'optimisé pour une exactitude maximale, l\'utilisateur est invité à vérifier les résultats avec ses supports de cours officiels.'
                    : 'The AI tutor is a learning companion designed to foster comprehension. Although optimized for high accuracy, users are encouraged to cross-reference answers with official school textbooks and curriculum.',
              ),
              _BulletPoint(
                title: isFr ? 'Comportement acceptable : ' : 'Acceptable use: ',
                body: isFr
                    ? 'Il est strictement interdit d\'utiliser le tuteur IA à des fins illicites, haineuses ou de tentative d\'exploitation technique des serveurs.'
                    : 'It is strictly forbidden to use the AI tutor for unlawful purposes, abusive behavior, or attempts to exploit server infrastructure.',
              ),
              _BulletPoint(
                title: isFr
                    ? 'Propriété intellectuelle : '
                    : 'Intellectual property: ',
                body: isFr
                    ? 'L\'architecture, la marque, les logos et les modules logiciels de Ngenou sont la propriété exclusive de Yamga Mokube Franck Daniel.'
                    : 'All architecture, brand names, logos, and software modules of Ngenou are the exclusive property of Yamga Mokube Franck Daniel.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TocButton extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TocButton({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.cyan.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 16,
              decoration: BoxDecoration(
                color: isActive ? AppColors.cyan : Colors.transparent,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: isActive ? AppColors.cyan : AppColors.textMuted,
                  fontSize: 13,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TocChip extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _TocChip({
    required this.title,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isActive
              ? AppColors.cyan.withValues(alpha: 0.15)
              : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isActive ? AppColors.cyan : AppColors.cardBorder,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? AppColors.cyan : AppColors.textMuted,
            fontSize: 13,
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _LegalArticle extends StatelessWidget {
  final IconData icon;
  final Color accent;
  final String number;
  final String title;
  final Widget child;

  const _LegalArticle({
    super.key,
    required this.icon,
    required this.accent,
    required this.number,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 32),
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: accent, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  '$number. $title',
                  style: GoogleFonts.fraunces(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.cardBorder),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String title;
  final String body;

  const _BulletPoint({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
            width: 5,
            height: 5,
            decoration: const BoxDecoration(
              color: AppColors.cyan,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 14, height: 1.6),
                children: [
                  TextSpan(
                    text: title,
                    style: const TextStyle(
                      color: AppColors.text,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  TextSpan(
                    text: body,
                    style: const TextStyle(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
