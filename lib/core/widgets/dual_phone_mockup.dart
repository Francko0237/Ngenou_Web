import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Widget de présentation double téléphone en composition décalée
/// Reproduit l'esthétique de la référence : fond sombre, deux mobiles
/// légèrement inclinés à des profondeurs différentes avec halos de lumière.
class DualPhoneMockup extends StatelessWidget {
  /// Chemin vers la capture d'écran du téléphone arrière (gauche)
  final String backImagePath;

  /// Chemin vers la capture d'écran du téléphone avant (droit)
  final String frontImagePath;

  /// Largeur totale de la composition (responsive)
  final double width;

  const DualPhoneMockup({
    super.key,
    required this.backImagePath,
    required this.frontImagePath,
    this.width = 420,
  });

  @override
  Widget build(BuildContext context) {
    final phoneWidth = width * 0.52;
    final phoneHeight = phoneWidth * 2.08;
    final backPhoneWidth = width * 0.46;
    final backPhoneHeight = backPhoneWidth * 2.08;

    return SizedBox(
      width: width,
      height: phoneHeight + 60,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // ── Halo arrière gold (derrière le téléphone gauche) ──────────────
          Positioned(
            left: width * 0.05,
            top: 40,
            child: Container(
              width: backPhoneWidth * 1.4,
              height: backPhoneHeight * 0.9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.gold.withValues(alpha: 0.22),
                    AppColors.gold.withValues(alpha: 0.06),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // ── Halo avant cyan (derrière le téléphone droit) ─────────────────
          Positioned(
            right: width * 0.00,
            top: 20,
            child: Container(
              width: phoneWidth * 1.3,
              height: phoneHeight * 0.85,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.cyan.withValues(alpha: 0.28),
                    AppColors.cyan.withValues(alpha: 0.08),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // ── Téléphone ARRIÈRE (gauche, légèrement incliné, recouvert) ─────
          Positioned(
            left: 0,
            top: 30,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(-0.14)
                ..rotateZ(-0.13),
              child: _PhoneFrame(
                imagePath: backImagePath,
                width: backPhoneWidth,
                height: backPhoneHeight,
                glowColor: AppColors.gold,
              ),
            ),
          ),

          // ── Téléphone AVANT (droit, en avant-plan) ────────────────────────
          Positioned(
            right: 0,
            top: 0,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(0.08)
                ..rotateZ(0.09),
              child: _PhoneFrame(
                imagePath: frontImagePath,
                width: phoneWidth,
                height: phoneHeight,
                glowColor: AppColors.cyan,
                isElevated: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Cadre téléphone individuel avec rendu réaliste
class _PhoneFrame extends StatelessWidget {
  final String imagePath;
  final double width;
  final double height;
  final Color glowColor;
  final bool isElevated;

  const _PhoneFrame({
    required this.imagePath,
    required this.width,
    required this.height,
    required this.glowColor,
    this.isElevated = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = width * 0.11;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFF0A1020),
        borderRadius: BorderRadius.circular(radius),
        // Cadre externe du téléphone (bord biseau léger)
        border: Border.all(
          color: const Color(0xFF2A3D5A),
          width: isElevated ? 3.0 : 2.5,
        ),
        boxShadow: [
          // Ombre principale réaliste
          BoxShadow(
            color: Colors.black.withValues(alpha: isElevated ? 0.7 : 0.55),
            blurRadius: isElevated ? 48 : 32,
            spreadRadius: isElevated ? -6 : -8,
            offset: Offset(isElevated ? 12 : 8, isElevated ? 24 : 16),
          ),
          // Lueur colorée en bas
          BoxShadow(
            color: glowColor.withValues(alpha: isElevated ? 0.30 : 0.18),
            blurRadius: isElevated ? 60 : 40,
            spreadRadius: isElevated ? -8 : -12,
            offset: Offset(0, isElevated ? 32 : 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius - 2),
        child: Stack(
          children: [
            // ── Screenshot ──────────────────────────────────────────────────
            Positioned.fill(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                errorBuilder: (context, error, _) => Container(
                  color: const Color(0xFF0D1A2E),
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported_rounded,
                      color: Color(0xFF3A5080),
                      size: 32,
                    ),
                  ),
                ),
              ),
            ),

            // ── Reflet de vitre (gradient lumineux en haut) ─────────────────
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: height * 0.35,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // ── Encoche Dynamic Island ──────────────────────────────────────
            Positioned(
              top: 8,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: width * 0.26,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.85),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F1E38),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // ── Barre de navigation inférieure ──────────────────────────────
            Positioned(
              bottom: 7,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: width * 0.32,
                  height: 3.5,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.45),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ),

            // ── Bordure interne subtile (effet biseauté) ────────────────────
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(radius - 2),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.06),
                    width: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
