import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../localization/app_language.dart';
import '../theme/app_colors.dart';

/// Sélecteur de langue segmented control avec glissement fluide et géométrie uniforme
class LanguageSwitcher extends ConsumerStatefulWidget {
  final bool isCompact;

  const LanguageSwitcher({
    super.key,
    this.isCompact = false,
  });

  @override
  ConsumerState<LanguageSwitcher> createState() => _LanguageSwitcherState();
}

class _LanguageSwitcherState extends ConsumerState<LanguageSwitcher> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    final currentLang = ref.watch(appLanguageProvider);
    final notifier = ref.read(appLanguageProvider.notifier);
    final isFr = currentLang == AppLanguage.fr;

    // Dimensions parfaitement calculées pour une symétrie et une uniformité totales
    final double slotWidth = widget.isCompact ? 38.0 : 44.0;
    final double slotHeight = widget.isCompact ? 26.0 : 30.0;
    const double padding = 3.0;

    final double totalWidth = (slotWidth * 2) + (padding * 2);
    final double totalHeight = slotHeight + (padding * 2);

    return Container(
      width: totalWidth,
      height: totalHeight,
      padding: const EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: const Color(0xFF0B1426),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: const Color(0xFF1E2D4A),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.35),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
          BoxShadow(
            color: AppColors.cyan.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Pilule active glissante (animation fluide)
          AnimatedAlign(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            alignment: isFr ? Alignment.centerLeft : Alignment.centerRight,
            child: Container(
              width: slotWidth,
              height: slotHeight,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [
                    AppColors.cyan,
                    Color(0xFF00B4D8),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(999),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.cyan.withValues(alpha: 0.40),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            ),
          ),

          // Options texte FR et EN
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildOption(
                label: 'FR',
                index: 0,
                isSelected: isFr,
                width: slotWidth,
                height: slotHeight,
                onTap: () => notifier.setLanguage(AppLanguage.fr),
              ),
              _buildOption(
                label: 'EN',
                index: 1,
                isSelected: !isFr,
                width: slotWidth,
                height: slotHeight,
                onTap: () => notifier.setLanguage(AppLanguage.en),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String label,
    required int index,
    required bool isSelected,
    required double width,
    required double height,
    required VoidCallback onTap,
  }) {
    final isHovered = _hoveredIndex == index;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: SizedBox(
          width: width,
          height: height,
          child: Center(
            child: AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 180),
              style: GoogleFonts.manrope(
                fontSize: widget.isCompact ? 11.5 : 12.5,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF040A14)
                    : (isHovered
                        ? AppColors.text
                        : const Color(0xFF8E9CB2)),
                letterSpacing: 0.5,
              ),
              child: Text(label),
            ),
          ),
        ),
      ),
    );
  }
}
