import 'dart:ui';
import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';
import 'download_button.dart';
import 'responsive_layout.dart';

/// Barre de navigation principale du site public Ngenou
class SiteNavbar extends StatelessWidget implements PreferredSizeWidget {
  final Function(String section)? onSectionSelected;

  const SiteNavbar({super.key, this.onSectionSelected});

  @override
  Size get preferredSize => const Size.fromHeight(76);

  void _handleNav(BuildContext context, String target) {
    if (target.startsWith('#')) {
      final section = target.substring(1);
      final currentRoute = GoRouterState.of(context).uri.toString();
      if (currentRoute != '/') {
        context.go('/');
        Future.delayed(const Duration(milliseconds: 300), () {
          onSectionSelected?.call(section);
        });
      } else {
        onSectionSelected?.call(section);
      }
    } else {
      context.go(target);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile =
        Responsive.isMobile(context) || Responsive.isTablet(context);

    // ==========================================
    // VERSION MOBILE / TABLETTE : PILULE FLOTTANTE
    // ==========================================
    if (isMobile) {
      return SizedBox(
        height: 76,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Halo or décoratif en arrière-plan
            Positioned(
              top: -40,
              right: -40,
              child: IgnorePointer(
                child: ImageFiltered(
                  imageFilter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                  child: Container(
                    width: 180,
                    height: 180,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.gold.withValues(alpha: 0.35),
                          AppColors.gold.withValues(alpha: 0.12),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Barre de navigation flottante en pilule avec backdrop blur
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                    child: Container(
                      height: 54,
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0C162E).withValues(alpha: 0.82),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.cardBorder.withValues(alpha: 0.85),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.38),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                          BoxShadow(
                            color: AppColors.cyan.withValues(alpha: 0.04),
                            blurRadius: 30,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Logo & Titre
                          InkWell(
                            onTap: () => context.go('/'),
                            borderRadius: BorderRadius.circular(999),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 4,
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Image.asset(
                                    'assets/images/logo.png',
                                    width: 32,
                                    height: 32,
                                    errorBuilder: (_, __, ___) => const Icon(
                                      Icons.school_rounded,
                                      color: AppColors.cyan,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'Ngenou',
                                    style: GoogleFonts.fraunces(
                                      fontSize: 21,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.text,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Menu Hamburger
                          _AnimatedMenuButton(
                            onPressed: () => _openMobileMenu(context),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }

    // ==========================================
    // VERSION DESKTOP : Barre avec backdrop blur
    // ==========================================
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 76,
          decoration: BoxDecoration(
            color: AppColors.background.withValues(alpha: 0.80),
            border: const Border(
              bottom: BorderSide(color: AppColors.cardBorder, width: 1),
            ),
          ),
          child: ResponsiveContainer(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo & Titre
                InkWell(
                  onTap: () => context.go('/'),
                  borderRadius: BorderRadius.circular(10),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          width: 36,
                          height: 36,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.school_rounded,
                            color: AppColors.cyan,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          'Ngenou',
                          style: GoogleFonts.fraunces(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: AppColors.text,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Liens Desktop
                Row(
                  children: [
                    _NavLink(
                      title: 'Aperçu',
                      onTap: () => _handleNav(context, '#showcase'),
                    ),
                    _NavLink(
                      title: 'Fonctionnalités',
                      onTap: () => _handleNav(context, '#features'),
                    ),
                    _NavLink(
                      title: 'Nouveautés',
                      onTap: () => _handleNav(context, '/nouveautes'),
                    ),
                    _NavLink(
                      title: 'FAQ',
                      onTap: () => _handleNav(context, '#faq'),
                    ),
                    _NavLink(
                      title: 'Confidentialité & CGU',
                      onTap: () => _handleNav(context, '/confidentialite'),
                    ),
                  ],
                ),
                const DownloadButton(isCompact: true),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openMobileMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => _MobileMenuSheet(
        onNavSelected: (target) {
          Navigator.pop(sheetContext);
          _handleNav(context, target);
        },
      ),
    );
  }
}

/// Bouton hamburger avec animation
class _AnimatedMenuButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _AnimatedMenuButton({required this.onPressed});

  @override
  State<_AnimatedMenuButton> createState() => _AnimatedMenuButtonState();
}

class _AnimatedMenuButtonState extends State<_AnimatedMenuButton> {
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
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _hovering
                ? AppColors.cardHover.withValues(alpha: 0.6)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            Icons.menu_rounded,
            color: _hovering ? AppColors.text : AppColors.text.withValues(alpha: 0.85),
            size: 24,
          ),
        ),
      ),
    );
  }
}

/// Sheet de menu mobile amélioré
class _MobileMenuSheet extends StatelessWidget {
  final void Function(String) onNavSelected;

  const _MobileMenuSheet({required this.onNavSelected});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF0E1830).withValues(alpha: 0.96),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
            border: Border.all(
              color: AppColors.cardBorder.withValues(alpha: 0.6),
              width: 1,
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.cardBorder.withValues(alpha: 1.0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Titre du menu
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Text(
                          'Navigation',
                          style: GoogleFonts.fraunces(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),

                  _MenuTile(
                    icon: Icons.phone_iphone_rounded,
                    title: 'Aperçu de l\'application',
                    iconColor: AppColors.cyan,
                    onTap: () => onNavSelected('#showcase'),
                  ),
                  _MenuTile(
                    icon: Icons.auto_awesome_rounded,
                    title: 'Fonctionnalités',
                    iconColor: AppColors.gold,
                    onTap: () => onNavSelected('#features'),
                  ),
                  _MenuTile(
                    icon: Icons.history_rounded,
                    title: 'Nouveautés & Mises à jour',
                    iconColor: AppColors.cyan,
                    onTap: () => onNavSelected('/nouveautes'),
                  ),
                  _MenuTile(
                    icon: Icons.help_outline_rounded,
                    title: 'FAQ',
                    iconColor: AppColors.gold,
                    onTap: () => onNavSelected('#faq'),
                  ),
                  _MenuTile(
                    icon: Icons.policy_rounded,
                    title: 'Confidentialité & CGU',
                    iconColor: AppColors.textMuted,
                    onTap: () => onNavSelected('/confidentialite'),
                  ),
                  const SizedBox(height: 20),

                  // Bouton téléchargement pleine largeur
                  SizedBox(
                    width: double.infinity,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: AppColors.cardBorder.withValues(alpha: 0.5),
                        ),
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const DownloadButton(),
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Tuile de menu mobile avec hover
class _MenuTile extends StatefulWidget {
  final IconData icon;
  final String title;
  final Color iconColor;
  final VoidCallback onTap;

  const _MenuTile({
    required this.icon,
    required this.title,
    required this.iconColor,
    required this.onTap,
  });

  @override
  State<_MenuTile> createState() => _MenuTileState();
}

class _MenuTileState extends State<_MenuTile> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          margin: const EdgeInsets.symmetric(vertical: 3),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: _hovering
                ? AppColors.cardHover.withValues(alpha: 0.7)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: widget.iconColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 18),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  widget.title,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward_ios_rounded,
                color: AppColors.textMuted.withValues(alpha: 0.5),
                size: 14,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Lien de navigation desktop avec hover élégant
class _NavLink extends StatefulWidget {
  final String title;
  final VoidCallback onTap;

  const _NavLink({required this.title, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: MouseRegion(
        onEnter: (_) => setState(() => _hovering = true),
        onExit: (_) => setState(() => _hovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _hovering
                  ? AppColors.cardHover.withValues(alpha: 0.5)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              widget.title,
              style: TextStyle(
                color: _hovering ? AppColors.text : AppColors.text.withValues(alpha: 0.80),
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
