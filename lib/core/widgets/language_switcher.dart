import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../localization/app_language.dart';
import '../theme/app_colors.dart';

/// Sélecteur de langue élégant pour la barre de navigation
class LanguageSwitcher extends ConsumerWidget {
  final bool isCompact;

  const LanguageSwitcher({
    super.key,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLang = ref.watch(appLanguageProvider);
    final notifier = ref.read(appLanguageProvider.notifier);

    return Container(
      height: isCompact ? 34 : 38,
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1832).withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppColors.cardBorder.withValues(alpha: 0.9),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.25),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Globe icon
          Padding(
            padding: EdgeInsets.only(
              left: isCompact ? 5 : 8,
              right: isCompact ? 3 : 5,
            ),
            child: Icon(
              Icons.language_rounded,
              color: AppColors.cyan,
              size: isCompact ? 14 : 16,
            ),
          ),
          _LangPill(
            label: 'FR',
            isSelected: currentLang == AppLanguage.fr,
            isCompact: isCompact,
            onTap: () => notifier.setLanguage(AppLanguage.fr),
          ),
          _LangPill(
            label: 'EN',
            isSelected: currentLang == AppLanguage.en,
            isCompact: isCompact,
            onTap: () => notifier.setLanguage(AppLanguage.en),
          ),
        ],
      ),
    );
  }
}

class _LangPill extends StatefulWidget {
  final String label;
  final bool isSelected;
  final bool isCompact;
  final VoidCallback onTap;

  const _LangPill({
    required this.label,
    required this.isSelected,
    required this.isCompact,
    required this.onTap,
  });

  @override
  State<_LangPill> createState() => _LangPillState();
}

class _LangPillState extends State<_LangPill> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.symmetric(
            horizontal: widget.isCompact ? 8 : 11,
            vertical: widget.isCompact ? 3 : 5,
          ),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? const LinearGradient(
                    colors: [AppColors.cyan, Color(0xFF0096B4)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.isSelected
                ? null
                : (_hovering
                    ? AppColors.cardHover.withValues(alpha: 0.6)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(999),
            boxShadow: widget.isSelected
                ? [
                    BoxShadow(
                      color: AppColors.cyan.withValues(alpha: 0.35),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            widget.label,
            style: GoogleFonts.manrope(
              fontSize: widget.isCompact ? 11 : 12.5,
              fontWeight:
                  widget.isSelected ? FontWeight.w800 : FontWeight.w600,
              color: widget.isSelected
                  ? const Color(0xFF050B17)
                  : (_hovering
                      ? AppColors.text
                      : AppColors.textMuted),
              letterSpacing: 0.4,
            ),
          ),
        ),
      ),
    );
  }
}
