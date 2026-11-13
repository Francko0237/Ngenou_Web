import 'package:material_ui/material_ui.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';

/// Widget de présentation double smartphone réaliste en composition décalée
/// avec animations de flottement discrètes et effets de profondeur immersifs.
class DualPhoneMockup extends StatefulWidget {
  /// Capture d'écran du téléphone avant (gauche, premier plan)
  final String frontImagePath;

  /// Capture d'écran du téléphone arrière (droit, arrière-plan)
  final String backImagePath;

  /// Largeur totale souhaitée de la composition
  final double width;

  /// Couleur d'accentuation pour l'ambiance lumineuse
  final Color? glowColor;

  /// Désactive les animations (prefers-reduced-motion)
  final bool disableAnimations;

  const DualPhoneMockup({
    super.key,
    required this.frontImagePath,
    required this.backImagePath,
    this.width = 440,
    this.glowColor,
    this.disableAnimations = false,
  });

  @override
  State<DualPhoneMockup> createState() => _DualPhoneMockupState();
}

class _DualPhoneMockupState extends State<DualPhoneMockup>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _glowController;
  late Animation<double> _floatAnimation;
  late Animation<double> _floatAnimationBack;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    );
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 4000),
    );

    _floatAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _floatAnimationBack = Tween<double>(begin: 1, end: 0).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.7, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    if (!widget.disableAnimations) {
      _floatController.repeat(reverse: true);
      _glowController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _floatController.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final phoneWidth = widget.width * 0.55;
    final phoneHeight = phoneWidth * 1.984;
    final totalHeight = phoneHeight + 70;
    final accentGlow = widget.glowColor ?? AppColors.gold;

    if (widget.disableAnimations) {
      return _buildStatic(phoneWidth, phoneHeight, totalHeight, accentGlow);
    }

    return AnimatedBuilder(
      animation: Listenable.merge([_floatAnimation, _glowAnimation]),
      builder: (context, _) {
        final floatOffset = _floatAnimation.value * 10.0;
        final floatOffsetBack = _floatAnimationBack.value * 7.0;
        final glowOpacity = _glowAnimation.value;

        return SizedBox(
          width: widget.width,
          height: totalHeight,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // ── 1. Halo lumineux central animé ──────────────────────────────
              Positioned(
                left: widget.width * 0.08,
                top: 10,
                child: IgnorePointer(
                  child: Container(
                    width: widget.width * 0.84,
                    height: phoneHeight * 0.9,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          accentGlow.withValues(alpha: 0.22 * glowOpacity),
                          accentGlow.withValues(alpha: 0.08 * glowOpacity),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.45, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // ── 2. Halo cyan secondaire animé ───────────────────────────────
              Positioned(
                right: widget.width * 0.0,
                bottom: 20,
                child: IgnorePointer(
                  child: Container(
                    width: phoneWidth * 1.3,
                    height: phoneHeight * 0.7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          AppColors.cyan.withValues(
                              alpha: 0.18 * (1.0 - _glowAnimation.value + 0.7)),
                          AppColors.cyan.withValues(alpha: 0.04),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                ),
              ),

              // ── 3. Téléphone ARRIÈRE (flottement décalé) ───────────────────
              Positioned(
                right: widget.width * 0.01,
                top: 15 + floatOffsetBack,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(0.08)
                    ..rotateZ(0.12),
                  child: _RealisticPhone(
                    imagePath: widget.backImagePath,
                    width: phoneWidth,
                    height: phoneHeight,
                    isElevated: false,
                  ),
                ),
              ),

              // ── 4. Téléphone AVANT (flottement principal) ──────────────────
              Positioned(
                left: widget.width * 0.01,
                top: 40 + floatOffset,
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(-0.10)
                    ..rotateZ(-0.18),
                  child: _RealisticPhone(
                    imagePath: widget.frontImagePath,
                    width: phoneWidth,
                    height: phoneHeight,
                    isElevated: true,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatic(
      double phoneWidth, double phoneHeight, double totalHeight, Color accentGlow) {
    return SizedBox(
      width: widget.width,
      height: totalHeight,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            left: widget.width * 0.12,
            top: 20,
            child: IgnorePointer(
              child: Container(
                width: widget.width * 0.76,
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
          Positioned(
            right: widget.width * 0.02,
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
          Positioned(
            right: widget.width * 0.01,
            top: 15,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(0.08)
                ..rotateZ(0.12),
              child: _RealisticPhone(
                imagePath: widget.backImagePath,
                width: phoneWidth,
                height: phoneHeight,
                isElevated: false,
              ),
            ),
          ),
          Positioned(
            left: widget.width * 0.01,
            top: 40,
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..rotateY(-0.10)
                ..rotateZ(-0.18),
              child: _RealisticPhone(
                imagePath: widget.frontImagePath,
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
          BoxShadow(
            color: Colors.black.withValues(alpha: isElevated ? 0.72 : 0.52),
            blurRadius: isElevated ? 42 : 28,
            spreadRadius: isElevated ? -3 : -6,
            offset: Offset(isElevated ? 12 : 8, isElevated ? 22 : 14),
          ),
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
            padding:
                EdgeInsets.fromLTRB(leftInset, topInset, rightInset, bottomInset),
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

          // ── C. Reflet de verre supérieur ────────────────────────────────
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

          // ── D. Cadre matériel réaliste ──────────────────────────────────
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
