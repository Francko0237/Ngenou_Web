import 'package:material_ui/material_ui.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app_release.dart';
import '../theme/app_colors.dart';
import '../utils/device_architecture_detector.dart';

/// Boîte de dialogue épurée de sélection de l'architecture Android (32 bits / 64 bits)
class DownloadArchitectureDialog extends StatelessWidget {
  final AppRelease? release;
  final AndroidArchitecture detectedArch;
  final VoidCallback? onDownloaded;

  const DownloadArchitectureDialog({
    super.key,
    required this.release,
    required this.detectedArch,
    this.onDownloaded,
  });

  /// Affiche la boîte de dialogue après avoir détecté l'architecture du téléphone
  static Future<void> show(
    BuildContext context, {
    required AppRelease? release,
    VoidCallback? onDownloaded,
  }) async {
    // 1. Détection automatique de l'architecture
    final arch = await DeviceArchitectureDetector.detect();

    if (!context.mounted) return;

    // 2. Affichage du dialogue adapté
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) => DownloadArchitectureDialog(
        release: release,
        detectedArch: arch,
        onDownloaded: onDownloaded,
      ),
    );
  }

  Future<void> _handleDownload(BuildContext context, String url) async {
    Navigator.of(context).pop();
    final uri = Uri.parse(url);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
        webOnlyWindowName: '_self',
      );
      if (launched) {
        onDownloaded?.call();
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Row(
                children: [
                  Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                  SizedBox(width: 10),
                  Text('Téléchargement en cours...'),
                ],
              ),
              backgroundColor: const Color(0xFF0D172A),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              duration: const Duration(seconds: 4),
            ),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Impossible de démarrer le téléchargement.'),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final arm64Url = release?.effectiveArm64Url ??
        'https://github.com/Francko0237/Ngenou_Web/releases/latest/download/ngenou-arm64.apk';
    final arm32Url = release?.effectiveArm32Url ??
        'https://github.com/Francko0237/Ngenou_Web/releases/latest/download/ngenou-arm32.apk';

    final isArm64Recommended = detectedArch == AndroidArchitecture.arm64;
    final isArm32Recommended = detectedArch == AndroidArchitecture.arm32;

    // Définition des deux cartes de version
    final arm64Option = _VersionOption(
      title: 'Version 64 bits (ARM64)',
      subtitle: 'Pour la grande majorité des téléphones récents (Android 8+)',
      url: arm64Url,
      isRecommended: isArm64Recommended,
    );

    final arm32Option = _VersionOption(
      title: 'Version 32 bits (ARMv7)',
      subtitle: 'Pour téléphones d\'entrée de gamme ou modèles plus anciens',
      url: arm32Url,
      isRecommended: isArm32Recommended,
    );

    // Ordre d'affichage :
    // - Si 32 bits détecté : 32 bits en 1er (Recommandée), puis 64 bits
    // - Si 64 bits détecté : 64 bits en 1er (Recommandée), puis 32 bits
    // - Si non détecté : 64 bits en 1er (sans mention), puis 32 bits (sans mention)
    final List<_VersionOption> options = isArm32Recommended
        ? [arm32Option, arm64Option]
        : [arm64Option, arm32Option];

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Container(
          padding: const EdgeInsets.all(26),
          decoration: BoxDecoration(
            color: const Color(0xFF0F1A33),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFF1E2E52), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.5),
                blurRadius: 40,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // En-tête : Icône + Titre + Bouton Fermer
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.cyan.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.android_rounded,
                      color: AppColors.cyan,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Télécharger Ngenou',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            color: AppColors.text,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          release?.versionName != null && release!.versionName.isNotEmpty
                              ? 'Version ${release!.versionName} • Android APK'
                              : 'Application Android',
                          style: const TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: AppColors.textMuted, size: 20),
                    tooltip: 'Fermer',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Sélectionnez la version adaptée à l\'architecture de votre processeur :',
                style: TextStyle(
                  fontSize: 13,
                  color: AppColors.textMuted,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),

              // Liste des options (1ère = recommandée si détectée, 2ème = standard)
              ...options.map((opt) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _VersionCard(
                    option: opt,
                    onTap: () => _handleDownload(context, opt.url),
                  ),
                );
              }),

              const SizedBox(height: 6),
              // Note discrète d'aide
              Center(
                child: Text(
                  detectedArch == AndroidArchitecture.unknown
                      ? '💡 En cas de doute, la version 64 bits convient à 95% des téléphones récents.'
                      : 'Les deux versions restent compatibles et téléchargeables à tout moment.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11.5,
                    color: AppColors.textMuted.withValues(alpha: 0.75),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VersionOption {
  final String title;
  final String subtitle;
  final String url;
  final bool isRecommended;

  const _VersionOption({
    required this.title,
    required this.subtitle,
    required this.url,
    required this.isRecommended,
  });
}

class _VersionCard extends StatefulWidget {
  final _VersionOption option;
  final VoidCallback onTap;

  const _VersionCard({
    required this.option,
    required this.onTap,
  });

  @override
  State<_VersionCard> createState() => _VersionCardState();
}

class _VersionCardState extends State<_VersionCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isRec = widget.option.isRecommended;

    // Couleurs selon recommandation et hover
    final borderColor = isRec
        ? (_isHovered ? AppColors.success : AppColors.success.withValues(alpha: 0.55))
        : (_isHovered ? AppColors.cyan.withValues(alpha: 0.6) : const Color(0xFF1E2E52));

    final bgColor = isRec
        ? (_isHovered ? const Color(0xFF142442) : const Color(0xFF101C38))
        : (_isHovered ? const Color(0xFF131D38) : const Color(0xFF0C142A));

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: borderColor, width: isRec ? 1.4 : 1.2),
            boxShadow: isRec
                ? [
                    BoxShadow(
                      color: AppColors.success.withValues(alpha: _isHovered ? 0.22 : 0.10),
                      blurRadius: _isHovered ? 18 : 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : [
                    if (_isHovered)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isRec
                      ? AppColors.success.withValues(alpha: 0.12)
                      : Colors.white.withValues(alpha: 0.05),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.download_rounded,
                  color: isRec ? AppColors.success : AppColors.text,
                  size: 20,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.option.title,
                            style: const TextStyle(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Badge Recommandée UNIQUEMENT sur la version recommandée
                        if (isRec) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.success.withValues(alpha: 0.35),
                                width: 1,
                              ),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle_rounded,
                                  size: 11,
                                  color: AppColors.success,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Recommandée',
                                  style: TextStyle(
                                    color: AppColors.success,
                                    fontSize: 10.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 3),
                    Text(
                      widget.option.subtitle,
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted.withValues(alpha: 0.9),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.arrow_forward_rounded,
                color: isRec
                    ? AppColors.success
                    : (_isHovered ? AppColors.text : AppColors.textMuted.withValues(alpha: 0.5)),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
