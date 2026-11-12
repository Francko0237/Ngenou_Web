import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Widget de présentation double smartphone réaliste en composition décalée
/// Reproduit fidèlement le design de référence :
/// - Téléphone gauche au premier plan (incliné -10° à -12°, avec ombre portée)
/// - Téléphone droit en arrière-plan (incliné +6° à +8°)
/// - Cadre matériel réaliste (châssis métallique, caméra poinçon, boutons latéraux)
/// - Halos lumineux d'ambiance (or chaud et cyan) sur fond sombre
class DualPhoneMockup extends StatelessWidget {
  /// Capture d'écran du téléphone avant (gauche, premier plan)
  final String frontImagePath;

  /// Capture d'écran du téléphone arrière (droit, arrière-plan)
  final String backImagePath;

  /// Largeur totale souhaitée de la composition
  final double width;

  /// Couleur d'accentuation pour l'ambiance lumineuse
  final Color? glowColor;

  const DualPhoneMockup({
    super.key,
    required this.frontImagePath,
    required this.backImagePath,
    this.width = 440,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    // Proportions basées sur le cadre matériel (562 x 1115 -> ratio ~1.984)
    final phoneWidth = width * 0.55;
    final phoneHeight = phoneWidth * 1.984;
    final totalHeight = phoneHeight + 70;
    final accentGlow = glowColor ?? AppColors.gold;

    return SizedBox(
      width: width,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // ── 1. Halo lumineux central chaud (derrière les deux téléphones) ──
          Positioned(
            left: width * 0.12,
            top: 20,
            child: IgnorePointer(
              child: Container(
                width: width * 0.76,
                height: phoneHeight * 0.85,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      accentGlow.withValues(alpha: 0.28),
                      accentGlow.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.45, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // ── 2. Halo d'accentuation cyan discret en bas à droite ───────────
          Positioned(
            right: width * 0.02,
            bottom: 30,
            child: IgnorePointer(
              child: Container(
                width: phoneWidth * 1.2,
                height: phoneHeight * 0.65,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.cyan.withValues(alpha: 0.20),
                      AppColors.cyan.withValues(alpha: 0.04),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // ── 3. Téléphone ARRIÈRE (droit, en second plan, incliné +8°) ─────
          Positioned(
            right: width * 0.01,
            top: 15,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(0.08)
                ..rotateZ(0.12),
              child: _RealisticPhone(
                imagePath: backImagePath,
                width: phoneWidth,
                height: phoneHeight,
                isElevated: false,
              ),
            ),
          ),

          // ── 4. Téléphone AVANT (gauche, au premier plan, incliné -11°) ───
          Positioned(
            left: width * 0.01,
            top: 40,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(-0.10)
                ..rotateZ(-0.18),
              child: _RealisticPhone(
                imagePath: frontImagePath,
                width: phoneWidth,
                height: phoneHeight,
                isElevated: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Rendu réaliste d'un smartphone moderne avec cadre matériel et reflets
class _RealisticPhone extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final bool isElevated;

  const _RealisticPhone({
    required this.imagePath,
    required this.width,
    required this.height,
    this.isElevated = false,
  });

  @override
  Widget build(BuildContext context) {
    // Ratios d'inset d'écran calculés d'après assets/screenshots/phone_frame.png
    // (562 de large, 1115 de haut, écran interne: gauche 14px, droite 24px, haut 22px, bas 22px)
    final leftInset = width * (14.0 / 562.0);
    final rightInset = width * (24.0 / 562.0);
    final topInset = height * (22.0 / 1115.0);
    final bottomInset = height * (22.0 / 1115.0);
    final screenRadius = width * 0.088;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(screenRadius),
        boxShadow: [
          // Ombre principale (au sol et sur le téléphone en arrière-plan)
          BoxShadow(
            color: Colors.black.withValues(alpha: isElevated ? 0.72 : 0.52),
            blurRadius: isElevated ? 42 : 28,
            spreadRadius: isElevated ? -3 : -6,
            offset: Offset(isElevated ? 12 : 8, isElevated ? 22 : 14),
          ),
          // Halo ambiant sous le téléphone
          if (isElevated)
            BoxShadow(
              color: AppColors.cyan.withValues(alpha: 0.16),
              blurRadius: 40,
              spreadRadius: -8,
              offset: const Offset(4, 16),
            ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ── A. Fond d'écran sombre ──────────────────────────────────────
          Padding(
            padding: EdgeInsets.fromLTRB(leftInset, topInset, rightInset, bottomInset),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF0A101D),
                borderRadius: BorderRadius.circular(screenRadius - 2),
              ),
            ),
          ),

          // ── B. Image d'écran de l'application ───────────────────────────
          Positioned(
            left: leftInset,
            top: topInset,
            right: rightInset,
            bottom: bottomInset,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(screenRadius - 2),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, _) => Container(
                  color: const Color(0xFF0D172A),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      color: Color(0xFF384E75),
                      size: 28,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── C. Reflet de verre supérieur (dégradé subtil de lumière) ────
          Positioned(
            left: leftInset,
            top: topInset,
            right: rightInset,
            height: height * 0.42,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(screenRadius - 2),
                topRight: Radius.circular(screenRadius - 2),
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.13),
                      Colors.white.withValues(alpha: 0.03),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.35, 0.75],
                  ),
                ),
              ),
            ),
          ),

          // ── D. Cadre matériel réaliste du téléphone (châssis métallique) ─
          IgnorePointer(
            child: Image.asset(
              'assets/screenshots/phone_frame.png',
              fit: BoxFit.fill,
              errorBuilder: (context, error, _) => _fallbackFrame(screenRadius),
            ),
          ),
        ],
      ),
    );
  }

  /// Cadre de secours vectoriel au cas où l'image de frame est indisponible
  Widget _fallbackFrame(double radius) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: const Color(0xFF2B3D5E),
          width: 3,
        ),
      ),
    );
  }
}
