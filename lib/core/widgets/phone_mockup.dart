import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Maquette de smartphone réaliste pour présenter les captures d'écran de l'application
/// Utilise le châssis matériel réaliste avec reflets et caméra poinçon
class PhoneMockup extends StatelessWidget {
  final String imagePath;
  final bool isNetwork;
  final double width;
  final double? height;
  final String? caption;

  const PhoneMockup({
    super.key,
    required this.imagePath,
    this.isNetwork = false,
    this.width = 300,
    this.height,
    this.caption,
  });

  @override
  Widget build(BuildContext context) {
    // Proportions basées sur le cadre matériel (ratio ~1.984)
    final calculatedHeight = height ?? (width * 1.984);
    final leftInset = width * (14.0 / 562.0);
    final rightInset = width * (24.0 / 562.0);
    final topInset = calculatedHeight * (22.0 / 1115.0);
    final bottomInset = calculatedHeight * (22.0 / 1115.0);
    final screenRadius = width * 0.088;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: width,
          height: calculatedHeight,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(screenRadius),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: 0.18),
                blurRadius: 36,
                spreadRadius: -6,
                offset: const Offset(0, 18),
              ),
              const BoxShadow(
                color: Colors.black54,
                blurRadius: 26,
                spreadRadius: -4,
                offset: Offset(0, 14),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // 1. Fond d'écran sombre
              Padding(
                padding: EdgeInsets.fromLTRB(leftInset, topInset, rightInset, bottomInset),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFF0A101D),
                    borderRadius: BorderRadius.circular(screenRadius - 2),
                  ),
                ),
              ),

              // 2. Image d'écran (réseau ou asset local)
              Positioned(
                left: leftInset,
                top: topInset,
                right: rightInset,
                bottom: bottomInset,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(screenRadius - 2),
                  child: isNetwork
                      ? CachedNetworkImage(
                          imageUrl: imagePath,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Container(
                            color: AppColors.card,
                            child: const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: AppColors.cyan,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: AppColors.card,
                            child: const Icon(
                              Icons.broken_image_rounded,
                              color: AppColors.textMuted,
                            ),
                          ),
                        )
                      : Image.asset(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                            color: AppColors.card,
                            child: const Center(
                              child: Icon(
                                Icons.image_not_supported_rounded,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ),
                        ),
                ),
              ),

              // 3. Reflet de verre supérieur (dégradé subtil)
              Positioned(
                left: leftInset,
                top: topInset,
                right: rightInset,
                height: calculatedHeight * 0.42,
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
                          Colors.white.withValues(alpha: 0.12),
                          Colors.white.withValues(alpha: 0.03),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.35, 0.75],
                      ),
                    ),
                  ),
                ),
              ),

              // 4. Cadre matériel réaliste du smartphone
              IgnorePointer(
                child: Image.asset(
                  'assets/screenshots/phone_frame.png',
                  fit: BoxFit.fill,
                  errorBuilder: (context, error, _) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(screenRadius),
                      border: Border.all(
                        color: const Color(0xFF223254),
                        width: 3.5,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (caption != null) ...[
          const SizedBox(height: 14),
          Text(
            caption!,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 13,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ],
    );
  }
}
