import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/localization/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/download_button.dart';
import '../../../core/widgets/gradient_text.dart';
import '../../../core/widgets/dual_phone_mockup.dart';
import '../../../core/widgets/phone_mockup.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/site_footer.dart';
import '../../../core/widgets/site_navbar.dart';

/// Page d'accueil vitrine de Ngenou — Refonte UI/UX premium avec internationalisation
class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _showcaseKey = GlobalKey();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _faqKey = GlobalKey();

  bool _imagesPrecached = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_imagesPrecached) {
      _imagesPrecached = true;
      const assetImages = [
        'assets/screenshots/Dashboard.png',
        'assets/screenshots/Cours.png',
        'assets/screenshots/phone_frame.png',
        'assets/screenshots/Ngenou2.png',
        'assets/screenshots/Defis1.png',
        'assets/screenshots/Defis2.png',
        'assets/screenshots/Assets1.png',
        'assets/screenshots/Assets2.png',
        'assets/screenshots/EmploieDetemps1.png',
        'assets/screenshots/EmploieDEtemps2.png',
        'assets/images/logo.png',
        'assets/images/logo_full.png',
      ];
      for (final asset in assetImages) {
        precacheImage(AssetImage(asset), context);
      }
    }
  }

  void _scrollToSection(String section) {
    GlobalKey? key;
    if (section == 'showcase') key = _showcaseKey;
    if (section == 'features') key = _featuresKey;
    if (section == 'faq') key = _faqKey;

    if (key?.currentContext != null) {
      Scrollable.ensureVisible(
        key!.currentContext!,
        duration: const Duration(milliseconds: 700),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final strings = ref.watch(appStringsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: SiteNavbar(onSectionSelected: _scrollToSection),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            RepaintBoundary(
              child: _HeroSection(
                strings: strings,
                onExplorePressed: () => _scrollToSection('showcase'),
                disableAnimations: disableAnimations,
              ),
            ),
            RepaintBoundary(
              child: _ShowcaseSection(
                key: _showcaseKey,
                strings: strings,
                disableAnimations: disableAnimations,
              ),
            ),
            RepaintBoundary(
              child: _BentoFeaturesSection(
                key: _featuresKey,
                strings: strings,
                disableAnimations: disableAnimations,
              ),
            ),
            RepaintBoundary(
              child: _DownloadCtaSection(
                strings: strings,
                disableAnimations: disableAnimations,
              ),
            ),
            RepaintBoundary(
              child: _FaqSection(
                key: _faqKey,
                strings: strings,
                disableAnimations: disableAnimations,
              ),
            ),
            const RepaintBoundary(child: SiteFooter()),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// HERO SECTION — Immersive & Cinématique
// =============================================================================
class _HeroSection extends StatefulWidget {
  final AppStrings strings;
  final VoidCallback onExplorePressed;
  final bool disableAnimations;

  const _HeroSection({
    required this.strings,
    required this.onExplorePressed,
    required this.disableAnimations,
  });

  @override
  State<_HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<_HeroSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _ambientController;
  late Animation<double> _ambientAnimation;

  @override
  void initState() {
    super.initState();
    _ambientController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 5000),
    );
    _ambientAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ambientController, curve: Curves.easeInOut),
    );
    if (!widget.disableAnimations) {
      _ambientController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _ambientController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isDesktop = Responsive.isDesktop(context);

    return AnimatedBuilder(
      animation: _ambientAnimation,
      builder: (context, child) {
        return Stack(
          children: [
            // Fond avec halos lumineux ambiants animés
            Positioned.fill(
              child: IgnorePointer(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: _AmbientGlowPainter(
                      progress: widget.disableAnimations
                          ? 0.5
                          : _ambientAnimation.value,
                    ),
                  ),
                ),
              ),
            ),
            child!,
          ],
        );
      },
      child: RepaintBoundary(
        child: Container(
          constraints: BoxConstraints(minHeight: isMobile ? 0 : 680),
          child: ResponsiveContainer(
            padding: EdgeInsets.symmetric(
              horizontal: Responsive.horizontalPadding(context),
              vertical: isMobile ? 40 : 72,
            ),
            child: isDesktop
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 6, child: _buildCopy(context)),
                      const SizedBox(width: 56),
                      Expanded(flex: 5, child: _buildVisual(context)),
                    ],
                  )
                : Column(
                    children: [
                      _buildCopy(context),
                      const SizedBox(height: 56),
                      _buildVisual(context),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCopy(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    final badgeWidget = widget.disableAnimations
        ? _buildBadge()
        : _buildBadge()
            .animate()
            .fadeIn(duration: 400.ms, delay: 100.ms)
            .slideY(begin: -0.2, end: 0, duration: 400.ms);

    final titleWidget = widget.disableAnimations
        ? _buildTitle(isMobile)
        : _buildTitle(isMobile)
            .animate()
            .fadeIn(duration: 600.ms, delay: 250.ms, curve: Curves.easeOut)
            .slideY(begin: 0.08, end: 0, duration: 600.ms, delay: 250.ms);

    final descWidget = widget.disableAnimations
        ? _buildDesc(isMobile)
        : _buildDesc(isMobile)
            .animate()
            .fadeIn(duration: 500.ms, delay: 450.ms)
            .slideY(begin: 0.06, end: 0, duration: 500.ms, delay: 450.ms);

    final ctaWidget = widget.disableAnimations
        ? _buildCta(isMobile)
        : _buildCta(isMobile)
            .animate()
            .fadeIn(duration: 500.ms, delay: 600.ms)
            .slideY(begin: 0.06, end: 0, duration: 500.ms, delay: 600.ms);

    final specsWidget = widget.disableAnimations
        ? _buildSpecs(isMobile)
        : _buildSpecs(isMobile)
            .animate()
            .fadeIn(duration: 500.ms, delay: 750.ms);

    return Column(
      crossAxisAlignment:
          isMobile ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        badgeWidget,
        const SizedBox(height: 20),
        titleWidget,
        const SizedBox(height: 22),
        descWidget,
        const SizedBox(height: 36),
        ctaWidget,
        const SizedBox(height: 40),
        specsWidget,
      ],
    );
  }

  Widget _buildBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: AppColors.cyan.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.cyan.withValues(alpha: 0.28),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: AppColors.cyan,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            widget.strings.heroBadge,
            style: GoogleFonts.manrope(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.cyan,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle(bool isMobile) {
    return RichText(
      textAlign: isMobile ? TextAlign.center : TextAlign.start,
      text: TextSpan(
        style: GoogleFonts.fraunces(
          fontSize: isMobile ? 36 : 56,
          fontWeight: FontWeight.w800,
          color: AppColors.text,
          height: 1.12,
          letterSpacing: -1.2,
        ),
        children: [
          TextSpan(text: widget.strings.heroTitlePart1),
          WidgetSpan(
            alignment: PlaceholderAlignment.baseline,
            baseline: TextBaseline.alphabetic,
            child: GradientText(
              widget.strings.heroTitleGradient,
              style: TextStyle(
                fontSize: isMobile ? 36 : 56,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.2,
                height: 1.12,
              ),
            ),
          ),
          TextSpan(text: widget.strings.heroTitlePart2),
        ],
      ),
    );
  }

  Widget _buildDesc(bool isMobile) {
    return Text(
      widget.strings.heroDesc,
      textAlign: isMobile ? TextAlign.center : TextAlign.start,
      style: GoogleFonts.manrope(
        fontSize: isMobile ? 15 : 17,
        color: AppColors.textMuted,
        height: 1.65,
      ),
    );
  }

  Widget _buildCta(bool isMobile) {
    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        const DownloadButton(),
        _ExploreButton(
          label: widget.strings.heroExploreButton,
          onPressed: widget.onExplorePressed,
        ),
      ],
    );
  }

  Widget _buildSpecs(bool isMobile) {
    return Wrap(
      spacing: 24,
      runSpacing: 14,
      alignment: isMobile ? WrapAlignment.center : WrapAlignment.start,
      children: [
        _HeroSpec(
          icon: Icons.wifi_off_rounded,
          text: widget.strings.heroSpecOffline,
          color: AppColors.cyan,
        ),
        _HeroSpec(
          icon: Icons.school_outlined,
          text: widget.strings.heroSpecLevels,
          color: AppColors.gold,
        ),
        _HeroSpec(
          icon: Icons.shield_outlined,
          text: widget.strings.heroSpecSecurity,
          color: AppColors.success,
        ),
      ],
    );
  }

  Widget _buildVisual(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final compositionWidth = isMobile ? 310.0 : 460.0;

    final visual = Center(
      child: DualPhoneMockup(
        frontImagePath: 'assets/screenshots/Dashboard.png',
        backImagePath: 'assets/screenshots/Cours.png',
        width: compositionWidth,
        glowColor: AppColors.gold,
        disableAnimations: widget.disableAnimations,
      ),
    );

    if (widget.disableAnimations) return visual;

    return visual
        .animate()
        .fadeIn(duration: 800.ms, delay: 350.ms, curve: Curves.easeOut)
        .slideY(begin: 0.04, end: 0, duration: 800.ms, delay: 350.ms);
  }
}

/// Peintre des halos ambiants du Hero
class _AmbientGlowPainter extends CustomPainter {
  final double progress;
  _AmbientGlowPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paintGold = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.gold.withValues(alpha: 0.14 + progress * 0.07),
          AppColors.gold.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: Offset(size.width * 0.85, -size.height * 0.1),
          radius: size.width * 0.5,
        ),
      );
    canvas.drawCircle(
      Offset(size.width * 0.85, -size.height * 0.1),
      size.width * 0.5,
      paintGold,
    );

    final paintCyan = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.cyan.withValues(alpha: 0.10 + (1 - progress) * 0.06),
          AppColors.cyan.withValues(alpha: 0.03),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(
        Rect.fromCircle(
          center: Offset(-size.width * 0.1, size.height * 1.1),
          radius: size.width * 0.55,
        ),
      );
    canvas.drawCircle(
      Offset(-size.width * 0.1, size.height * 1.1),
      size.width * 0.55,
      paintCyan,
    );
  }

  @override
  bool shouldRepaint(_AmbientGlowPainter old) => old.progress != progress;
}

/// Bouton "Voir l'application" avec hover animé
class _ExploreButton extends StatefulWidget {
  final String label;
  final VoidCallback onPressed;

  const _ExploreButton({
    required this.label,
    required this.onPressed,
  });

  @override
  State<_ExploreButton> createState() => _ExploreButtonState();
}

class _ExploreButtonState extends State<_ExploreButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 15),
          decoration: BoxDecoration(
            color: _hovering
                ? AppColors.cardHover
                : AppColors.card.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: _hovering
                  ? AppColors.cardBorder.withValues(alpha: 1.0)
                  : AppColors.cardBorder,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.label,
                style: GoogleFonts.manrope(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text,
                ),
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(left: _hovering ? 10 : 8),
                child: const Icon(
                  Icons.arrow_forward_rounded,
                  color: AppColors.text,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroSpec extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _HeroSpec({required this.icon, required this.text, this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: (color ?? AppColors.cyan).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: color ?? AppColors.cyan, size: 14),
        ),
        const SizedBox(width: 9),
        Text(
          text,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// =============================================================================
// SHOWCASE SECTION — Onglets interactifs avec aperçu dynamique
// =============================================================================
class _ShowcaseSection extends StatefulWidget {
  final AppStrings strings;
  final bool disableAnimations;

  const _ShowcaseSection({
    super.key,
    required this.strings,
    required this.disableAnimations,
  });

  static List<_ShowcaseTab> getTabs(AppStrings strings) => [
        _ShowcaseTab(
          title: strings.tabTutorTitle,
          icon: Icons.chat_bubble_outline_rounded,
          accent: AppColors.cyan,
          description: strings.tabTutorDesc,
          features: [
            strings.tabTutorFeat1,
            strings.tabTutorFeat2,
            strings.tabTutorFeat3,
            strings.tabTutorFeat4,
          ],
          frontScreenshot: 'assets/screenshots/Ngenou2.png',
          backScreenshot: 'assets/screenshots/Cours.png',
          caption: strings.tabTutorCaption,
        ),
        _ShowcaseTab(
          title: strings.tabDefisTitle,
          icon: Icons.emoji_events_outlined,
          accent: AppColors.gold,
          description: strings.tabDefisDesc,
          features: [
            strings.tabDefisFeat1,
            strings.tabDefisFeat2,
            strings.tabDefisFeat3,
          ],
          frontScreenshot: 'assets/screenshots/Defis1.png',
          backScreenshot: 'assets/screenshots/Defis2.png',
          caption: strings.tabDefisCaption,
        ),
        _ShowcaseTab(
          title: strings.tabAssetsTitle,
          icon: Icons.extension_outlined,
          accent: AppColors.cyan,
          description: strings.tabAssetsDesc,
          features: [
            strings.tabAssetsFeat1,
            strings.tabAssetsFeat2,
            strings.tabAssetsFeat3,
          ],
          frontScreenshot: 'assets/screenshots/Assets1.png',
          backScreenshot: 'assets/screenshots/Assets2.png',
          caption: strings.tabAssetsCaption,
        ),
        _ShowcaseTab(
          title: strings.tabPlanningTitle,
          icon: Icons.calendar_today_outlined,
          accent: AppColors.gold,
          description: strings.tabPlanningDesc,
          features: [
            strings.tabPlanningFeat1,
            strings.tabPlanningFeat2,
            strings.tabPlanningFeat3,
          ],
          frontScreenshot: 'assets/screenshots/EmploieDetemps1.png',
          backScreenshot: 'assets/screenshots/EmploieDEtemps2.png',
          caption: strings.tabPlanningCaption,
        ),
      ];

  @override
  State<_ShowcaseSection> createState() => _ShowcaseSectionState();
}

class _ShowcaseSectionState extends State<_ShowcaseSection> {
  int _selectedIndex = 0;
  bool _hasAppeared = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final tabs = _ShowcaseSection.getTabs(widget.strings);
    final activeTab = tabs[_selectedIndex.clamp(0, tabs.length - 1)];

    Widget content = Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      decoration: BoxDecoration(
        color: const Color(0xFF060D1E),
        border: Border.symmetric(
          horizontal: BorderSide(
            color: AppColors.cardBorder.withValues(alpha: 0.7),
            width: 1,
          ),
        ),
      ),
      child: ResponsiveContainer(
        child: Column(
          children: [
            _SectionHeader(
              title: widget.strings.showcaseTitle,
              subtitle: widget.strings.showcaseSubtitle,
              disableAnimations: widget.disableAnimations,
            ),
            const SizedBox(height: 56),

            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 6,
                    child: Column(
                      children: List.generate(tabs.length, (i) {
                        return _buildTabItem(context, tabs[i], i);
                      }),
                    ),
                  ),
                  const SizedBox(width: 56),
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 400),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeIn,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.05),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Column(
                          key: ValueKey(activeTab.frontScreenshot),
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DualPhoneMockup(
                              frontImagePath: activeTab.frontScreenshot,
                              backImagePath: activeTab.backScreenshot,
                              width: 390,
                              glowColor: activeTab.accent,
                              disableAnimations: widget.disableAnimations,
                            ),
                            const SizedBox(height: 20),
                            Text(
                              activeTab.caption,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            else
              Column(
                children: List.generate(tabs.length, (i) {
                  final tab = tabs[i];
                  final isSelected = _selectedIndex == i;
                  return Column(
                    children: [
                      _buildTabItem(context, tab, i),
                      if (isSelected) ...[
                        const SizedBox(height: 28),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DualPhoneMockup(
                                frontImagePath: tab.frontScreenshot,
                                backImagePath: tab.backScreenshot,
                                width: 300,
                                glowColor: tab.accent,
                                disableAnimations: widget.disableAnimations,
                              ),
                              const SizedBox(height: 14),
                              Text(
                                tab.caption,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 12,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                      ],
                    ],
                  );
                }),
              ),
          ],
        ),
      ),
    );

    if (widget.disableAnimations || _hasAppeared) return content;
    _hasAppeared = true;

    return content
        .animate()
        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
        .slideY(begin: 0.04, end: 0, duration: 600.ms);
  }

  Widget _buildTabItem(BuildContext context, _ShowcaseTab tab, int index) {
    final isSelected = _selectedIndex == index;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: _HoverCard(
        onTap: () => setState(() => _selectedIndex = index),
        isSelected: isSelected,
        accentColor: tab.accent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: tab.accent.withValues(
                      alpha: isSelected ? 0.20 : 0.12,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(tab.icon, color: tab.accent, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    tab.title,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: isSelected ? AppColors.text : AppColors.textMuted,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isSelected ? 0.25 : 0,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: isSelected
                        ? tab.accent
                        : AppColors.textMuted.withValues(alpha: 0.4),
                    size: 14,
                  ),
                ),
              ],
            ),
            if (isSelected) ...[
              const SizedBox(height: 16),
              Text(
                tab.description,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
              const SizedBox(height: 16),
              ...tab.features.map(
                (f) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: tab.accent,
                        size: 16,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          f,
                          style: const TextStyle(
                            color: AppColors.text,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ShowcaseTab {
  final String title;
  final IconData icon;
  final Color accent;
  final String description;
  final List<String> features;
  final String frontScreenshot;
  final String backScreenshot;
  final String caption;

  const _ShowcaseTab({
    required this.title,
    required this.icon,
    required this.accent,
    required this.description,
    required this.features,
    required this.frontScreenshot,
    required this.backScreenshot,
    required this.caption,
  });
}

// =============================================================================
// BENTO FEATURES SECTION
// =============================================================================
class _BentoFeaturesSection extends StatelessWidget {
  final AppStrings strings;
  final bool disableAnimations;

  const _BentoFeaturesSection({
    super.key,
    required this.strings,
    required this.disableAnimations,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    Widget content = Container(
      padding: const EdgeInsets.symmetric(vertical: 88),
      child: ResponsiveContainer(
        child: Column(
          children: [
            _SectionHeader(
              title: strings.bentoHeaderTitle,
              subtitle: strings.bentoHeaderSubtitle,
              disableAnimations: disableAnimations,
            ),
            const SizedBox(height: 56),

            if (isDesktop)
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Column(
                        children: [
                          _BentoCard(
                            icon: Icons.bolt_rounded,
                            accent: AppColors.cyan,
                            title: strings.bento1Title,
                            body: strings.bento1Body,
                            extraWidget: _SyncNodeVisual(strings: strings),
                            disableAnimations: disableAnimations,
                            delay: 100,
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: _BentoCard(
                                    icon: Icons.shield_rounded,
                                    accent: AppColors.cyan,
                                    title: strings.bento2Title,
                                    body: strings.bento2Body,
                                    extraWidget: _SecurityBadgeVisual(
                                      badgeText: strings.bentoSecurityBadge,
                                    ),
                                    disableAnimations: disableAnimations,
                                    delay: 200,
                                    isFullHeight: true,
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: _BentoCard(
                                    icon: Icons.lightbulb_rounded,
                                    accent: AppColors.gold,
                                    title: strings.bento3Title,
                                    body: strings.bento3Body,
                                    quote: strings.bento3Quote,
                                    disableAnimations: disableAnimations,
                                    delay: 300,
                                    isFullHeight: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      flex: 5,
                      child: _BentoCard(
                        icon: Icons.phone_android_rounded,
                        accent: AppColors.gold,
                        title: strings.bento4Title,
                        body: strings.bento4Body,
                        screenshot: 'assets/screenshots/Dashboard.png',
                        disableAnimations: disableAnimations,
                        delay: 400,
                        isFullHeight: true,
                      ),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  _BentoCard(
                    icon: Icons.bolt_rounded,
                    accent: AppColors.cyan,
                    title: strings.bento1Title,
                    body: strings.bento1Body,
                    extraWidget: _SyncNodeVisual(strings: strings),
                    disableAnimations: disableAnimations,
                    delay: 100,
                  ),
                  const SizedBox(height: 16),
                  _BentoCard(
                    icon: Icons.shield_rounded,
                    accent: AppColors.cyan,
                    title: strings.bento2Title,
                    body: strings.bento2Body,
                    extraWidget: _SecurityBadgeVisual(
                      badgeText: strings.bentoSecurityBadge,
                    ),
                    disableAnimations: disableAnimations,
                    delay: 150,
                  ),
                  const SizedBox(height: 16),
                  _BentoCard(
                    icon: Icons.lightbulb_rounded,
                    accent: AppColors.gold,
                    title: strings.bento3Title,
                    body: strings.bento3Body,
                    quote: strings.bento3Quote,
                    disableAnimations: disableAnimations,
                    delay: 200,
                  ),
                  const SizedBox(height: 16),
                  _BentoCard(
                    icon: Icons.phone_android_rounded,
                    accent: AppColors.gold,
                    title: strings.bento4Title,
                    body: strings.bento4Body,
                    screenshot: 'assets/screenshots/Dashboard.png',
                    disableAnimations: disableAnimations,
                    delay: 250,
                  ),
                ],
              ),
          ],
        ),
      ),
    );

    return content;
  }
}

class _BentoCard extends StatefulWidget {
  final IconData icon;
  final Color accent;
  final String title;
  final String body;
  final String? quote;
  final String? screenshot;
  final Widget? extraWidget;
  final bool disableAnimations;
  final int delay;
  final bool isFullHeight;

  const _BentoCard({
    required this.icon,
    required this.accent,
    required this.title,
    required this.body,
    this.quote,
    this.screenshot,
    this.extraWidget,
    this.disableAnimations = false,
    this.delay = 0,
    this.isFullHeight = false,
  });

  @override
  State<_BentoCard> createState() => _BentoCardState();
}

class _BentoCardState extends State<_BentoCard> {
  bool _hovering = false;
  bool _hasAppeared = false;

  @override
  Widget build(BuildContext context) {
    Widget card = MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        height: widget.isFullHeight ? double.infinity : null,
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(26),
        decoration: BoxDecoration(
          color: _hovering ? AppColors.cardHover : AppColors.card,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: _hovering
                ? widget.accent.withValues(alpha: 0.35)
                : AppColors.cardBorder,
            width: _hovering ? 1.5 : 1,
          ),
          boxShadow: _hovering
              ? [
                  BoxShadow(
                    color: widget.accent.withValues(alpha: 0.10),
                    blurRadius: 32,
                    offset: const Offset(0, 8),
                  ),
                ]
              : [],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: widget.isFullHeight
              ? MainAxisAlignment.spaceBetween
              : MainAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: widget.accent
                        .withValues(alpha: _hovering ? 0.22 : 0.14),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(widget.icon, color: widget.accent, size: 24),
                ),
                const SizedBox(height: 18),
                Text(
                  widget.title,
                  style: GoogleFonts.fraunces(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.body,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
            if (widget.quote != null) ...[
              const SizedBox(height: 18),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: widget.accent.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border(
                    left: BorderSide(color: widget.accent, width: 3),
                  ),
                ),
                child: Text(
                  widget.quote!,
                  style: TextStyle(
                    color: widget.accent,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ],
            if (widget.extraWidget != null) ...[
              const SizedBox(height: 18),
              widget.extraWidget!,
            ],
            if (widget.screenshot != null) ...[
              const SizedBox(height: 18),
              if (widget.isFullHeight)
                Expanded(
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      alignment: Alignment.bottomCenter,
                      child: PhoneMockup(
                        imagePath: widget.screenshot!,
                        width: 215,
                      ),
                    ),
                  ),
                )
              else
                Center(
                  child: PhoneMockup(
                    imagePath: widget.screenshot!,
                    width: 220,
                  ),
                ),
            ],
          ],
        ),
      ),
    );

    if (widget.disableAnimations || _hasAppeared) return card;
    _hasAppeared = true;

    return card
        .animate()
        .fadeIn(
          duration: 500.ms,
          delay: Duration(milliseconds: widget.delay),
          curve: Curves.easeOut,
        )
        .slideY(
          begin: 0.05,
          end: 0,
          duration: 500.ms,
          delay: Duration(milliseconds: widget.delay),
        );
  }
}

class _SecurityBadgeVisual extends StatelessWidget {
  final String badgeText;
  const _SecurityBadgeVisual({required this.badgeText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.cyan.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: const Border(
          left: BorderSide(color: AppColors.cyan, width: 3),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.shield_outlined, color: AppColors.cyan, size: 16),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              badgeText,
              style: const TextStyle(
                color: AppColors.cyan,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SyncNodeVisual extends StatefulWidget {
  final AppStrings strings;
  const _SyncNodeVisual({required this.strings});

  @override
  State<_SyncNodeVisual> createState() => _SyncNodeVisualState();
}

class _SyncNodeVisualState extends State<_SyncNodeVisual>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF070E20),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.cardBorder),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.phone_android_rounded,
                color: AppColors.cyan,
                size: 18,
              ),
              const SizedBox(width: 8),
              Text(
                widget.strings.bentoSyncPhone,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, _) => Row(
              children: [
                Container(
                  width: 28,
                  height: 1.5,
                  color: AppColors.cyan.withValues(
                    alpha: _pulseAnimation.value * 0.6,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: AppColors.cyan.withValues(
                            alpha: _pulseAnimation.value,
                          ),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.cyan.withValues(
                                alpha: _pulseAnimation.value * 0.5,
                              ),
                              blurRadius: 6,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        widget.strings.bentoSyncTag,
                        style: TextStyle(
                          color: AppColors.cyan.withValues(
                            alpha: _pulseAnimation.value,
                          ),
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 28,
                  height: 1.5,
                  color: AppColors.cyan.withValues(
                    alpha: _pulseAnimation.value * 0.6,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              const Icon(Icons.cloud_done_rounded, color: AppColors.gold, size: 18),
              const SizedBox(width: 8),
              Text(
                widget.strings.bentoSyncAccount,
                style: const TextStyle(
                  color: AppColors.text,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// DOWNLOAD CTA SECTION — Bannière de conversion premium
// =============================================================================
class _DownloadCtaSection extends StatelessWidget {
  final AppStrings strings;
  final bool disableAnimations;

  const _DownloadCtaSection({
    required this.strings,
    required this.disableAnimations,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    Widget content = Container(
      padding: const EdgeInsets.symmetric(vertical: 64),
      child: ResponsiveContainer(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 56 : 28,
                vertical: isDesktop ? 52 : 40,
              ),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D1C3A), Color(0xFF0A1328)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: AppColors.cardBorder.withValues(alpha: 0.8),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyan.withValues(alpha: 0.06),
                    blurRadius: 60,
                    offset: const Offset(0, 20),
                  ),
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.04),
                    blurRadius: 60,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: isDesktop
                  ? Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 230,
                              height: 230,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.gold.withValues(alpha: 0.15),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/images/logo_full.png',
                              width: 200,
                              height: 200,
                              cacheWidth: 400,
                              cacheHeight: 400,
                              filterQuality: FilterQuality.medium,
                              gaplessPlayback: true,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        const SizedBox(width: 48),
                        Expanded(child: _buildCtaContent()),
                      ],
                    )
                  : Column(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 200,
                              height: 200,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.gold.withValues(alpha: 0.15),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            Image.asset(
                              'assets/images/logo_full.png',
                              width: 170,
                              height: 170,
                              cacheWidth: 340,
                              cacheHeight: 340,
                              filterQuality: FilterQuality.medium,
                              gaplessPlayback: true,
                              fit: BoxFit.contain,
                            ),
                          ],
                        ),
                        const SizedBox(height: 28),
                        _buildCtaContent(),
                      ],
                    ),
            ),
            Positioned(
              top: -20,
              right: -20,
              child: IgnorePointer(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        AppColors.gold.withValues(alpha: 0.08),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    if (disableAnimations) return content;

    return content
        .animate()
        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
        .slideY(begin: 0.04, end: 0, duration: 600.ms);
  }

  Widget _buildCtaContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          strings.ctaTitle,
          style: GoogleFonts.fraunces(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: AppColors.text,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 14),
        Text(
          strings.ctaSubtitle,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 15,
            height: 1.65,
          ),
        ),
        const SizedBox(height: 32),
        const DownloadButton(),
      ],
    );
  }
}

// =============================================================================
// FAQ SECTION
// =============================================================================
class _FaqSection extends StatefulWidget {
  final AppStrings strings;
  final bool disableAnimations;

  const _FaqSection({
    super.key,
    required this.strings,
    required this.disableAnimations,
  });

  static List<_FaqItem> getItems(AppStrings strings) => [
        _FaqItem(
          question: strings.faq1Question,
          answer: strings.faq1Answer,
        ),
        _FaqItem(
          question: strings.faq2Question,
          answer: strings.faq2Answer,
        ),
        _FaqItem(
          question: strings.faq3Question,
          answer: strings.faq3Answer,
        ),
        _FaqItem(
          question: strings.faq4Question,
          answer: strings.faq4Answer,
        ),
      ];

  @override
  State<_FaqSection> createState() => _FaqSectionState();
}

class _FaqSectionState extends State<_FaqSection> {
  final Set<int> _expandedIndices = {0};
  bool _hasAppeared = false;

  void _toggle(int index) {
    setState(() {
      if (_expandedIndices.contains(index)) {
        _expandedIndices.remove(index);
      } else {
        _expandedIndices.add(index);
      }
    });
  }

  Future<void> _openSupportEmail() async {
    final uri = Uri.parse('mailto:ngenou.support@gmail.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _FaqSection.getItems(widget.strings);

    Widget content = Container(
      padding: const EdgeInsets.symmetric(vertical: 80),
      child: ResponsiveContainer(
        child: Column(
          children: [
            _SectionHeader(
              title: widget.strings.faqTitle,
              subtitle: null,
              disableAnimations: widget.disableAnimations,
            ),
            const SizedBox(height: 12),
            Wrap(
              alignment: WrapAlignment.center,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Text(
                  widget.strings.faqContactPrefix,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 15),
                ),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: _openSupportEmail,
                    child: const Text(
                      'ngenou.support@gmail.com',
                      style: TextStyle(
                        color: AppColors.cyan,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 52),

            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 820),
              child: Column(
                children: List.generate(items.length, (i) {
                  final item = items[i];
                  final isExpanded = _expandedIndices.contains(i);

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 14),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 250),
                      decoration: BoxDecoration(
                        color: isExpanded
                            ? AppColors.card
                            : AppColors.card.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isExpanded
                              ? AppColors.cyan.withValues(alpha: 0.4)
                              : AppColors.cardBorder,
                          width: isExpanded ? 1.5 : 1,
                        ),
                        boxShadow: isExpanded
                            ? [
                                BoxShadow(
                                  color: AppColors.cyan.withValues(alpha: 0.05),
                                  blurRadius: 24,
                                  offset: const Offset(0, 4),
                                ),
                              ]
                            : [],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: ExpansionTile(
                          key: Key('faq_${widget.strings.language.code}_$i'),
                          initiallyExpanded: isExpanded,
                          onExpansionChanged: (_) => _toggle(i),
                          shape: const Border(),
                          collapsedShape: const Border(),
                          iconColor: AppColors.cyan,
                          collapsedIconColor: AppColors.textMuted.withValues(
                            alpha: 0.6,
                          ),
                          tilePadding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 10,
                          ),
                          title: Text(
                            item.question,
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(24, 0, 24, 22),
                              child: Text(
                                item.answer,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 14,
                                  height: 1.65,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );

    if (widget.disableAnimations || _hasAppeared) return content;
    _hasAppeared = true;

    return content
        .animate()
        .fadeIn(duration: 600.ms, curve: Curves.easeOut)
        .slideY(begin: 0.04, end: 0, duration: 600.ms);
  }
}

class _FaqItem {
  final String question;
  final String answer;

  const _FaqItem({required this.question, required this.answer});
}

// =============================================================================
// COMPOSANTS PARTAGÉS
// =============================================================================

/// En-tête de section avec titre Fraunces et sous-titre
class _SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool disableAnimations;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    required this.disableAnimations,
  });

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    Widget titleWidget = Text(
      title,
      textAlign: TextAlign.center,
      style: GoogleFonts.fraunces(
        fontSize: isMobile ? 26 : 34,
        fontWeight: FontWeight.w700,
        color: AppColors.text,
        height: 1.2,
      ),
    );

    if (!disableAnimations) {
      titleWidget = titleWidget
          .animate()
          .fadeIn(duration: 500.ms, curve: Curves.easeOut)
          .slideY(begin: 0.05, end: 0, duration: 500.ms);
    }

    Widget? subtitleWidget;
    if (subtitle != null) {
      subtitleWidget = Padding(
        padding: const EdgeInsets.only(top: 14),
        child: Text(
          subtitle!,
          textAlign: TextAlign.center,
          style: GoogleFonts.manrope(
            fontSize: isMobile ? 15 : 16.5,
            color: AppColors.textMuted,
            height: 1.6,
          ),
        ),
      );

      if (!disableAnimations) {
        subtitleWidget = subtitleWidget
            .animate()
            .fadeIn(duration: 500.ms, delay: 150.ms)
            .slideY(begin: 0.04, end: 0, duration: 500.ms, delay: 150.ms);
      }
    }

    return Column(
      children: [
        Container(
          width: 36,
          height: 3,
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            gradient: AppColors.brandGradient,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
        titleWidget,
        if (subtitleWidget != null) subtitleWidget,
      ],
    );
  }
}

/// Carte interactive avec hover élégant pour les onglets showcase
class _HoverCard extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final bool isSelected;
  final Color accentColor;

  const _HoverCard({
    required this.child,
    required this.onTap,
    required this.isSelected,
    required this.accentColor,
  });

  @override
  State<_HoverCard> createState() => _HoverCardState();
}

class _HoverCardState extends State<_HoverCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.isSelected
                ? AppColors.cardHover
                : _hovering
                    ? AppColors.card.withValues(alpha: 0.9)
                    : AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: widget.isSelected
                  ? widget.accentColor.withValues(alpha: 0.6)
                  : _hovering
                      ? widget.accentColor.withValues(alpha: 0.2)
                      : AppColors.cardBorder,
              width: widget.isSelected ? 1.5 : 1,
            ),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: widget.accentColor.withValues(alpha: 0.10),
                      blurRadius: 24,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : [],
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
