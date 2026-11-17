import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app_release.dart';
import '../supabase/providers.dart';
import '../theme/app_colors.dart';

/// Bouton de téléchargement de l'APK Ngenou avec micro-interactions au survol
class DownloadButton extends ConsumerStatefulWidget {
  final bool isCompact;
  final VoidCallback? onDownloaded;

  const DownloadButton({
    super.key,
    this.isCompact = false,
    this.onDownloaded,
  });

  @override
  ConsumerState<DownloadButton> createState() => _DownloadButtonState();
}

class _DownloadButtonState extends ConsumerState<DownloadButton> {
  bool _isHovered = false;

  static const String defaultApkUrl =
      'https://github.com/Francko0237/Ngenou_Web/releases/latest/download/Ngenou.apk';

  Future<void> _launchDownload(
      BuildContext context, AppRelease? release) async {
    // 1. Fenêtre de confirmation intégrée à l'application
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFF0D172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Color(0xFF1E2E4A), width: 1),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.cyan.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.download_rounded,
                color: AppColors.cyan,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Télécharger Ngenou',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Voulez-vous lancer le téléchargement de l\'application Ngenou pour Android ?',
              style: TextStyle(
                color: Color(0xFFBAC7DF),
                fontSize: 14,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF070E20),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFF1E2E4A)),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.android_rounded,
                    color: AppColors.gold,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          release != null
                              ? 'Ngenou v${release.versionName}'
                              : 'Ngenou v1.1.1',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Fichier APK officiel • 100% sécurisé',
                          style: TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text(
              'Annuler',
              style: TextStyle(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFAF7F2),
              foregroundColor: const Color(0xFF0B1124),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
            child: const Text(
              'Télécharger',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // 2. Déclenchement du téléchargement en arrière-plan sans quitter la page
    final apkUrl = release?.apkUrl?.isNotEmpty == true
        ? release!.apkUrl!
        : defaultApkUrl;

    final uri = Uri.parse(apkUrl);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.platformDefault,
        webOnlyWindowName: '_self',
      );

      if (context.mounted) {
        if (launched) {
          widget.onDownloaded?.call();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Row(
                children: [
                  Icon(Icons.check_circle_rounded,
                      color: Colors.greenAccent, size: 20),
                  SizedBox(width: 10),
                  Text('Téléchargement lancé avec succès !'),
                ],
              ),
              backgroundColor: Color(0xFF0D172A),
              duration: Duration(seconds: 4),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Impossible de démarrer le téléchargement.'),
              backgroundColor: AppColors.error,
            ),
          );
        }
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erreur lors du téléchargement.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final latestReleaseAsync = ref.watch(latestReleaseProvider);
    final release = latestReleaseAsync.value;

    if (widget.isCompact) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: AnimatedScale(
          scale: _isHovered ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOutCubic,
          child: ElevatedButton.icon(
            onPressed: () => _launchDownload(context, release),
            icon: const Icon(Icons.download_rounded, size: 18),
            label: const Text(
              'Télécharger',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFAF7F2),
              foregroundColor: const Color(0xFF0B1124),
              elevation: _isHovered ? 6 : 3,
              shadowColor: AppColors.gold.withValues(alpha: _isHovered ? 0.5 : 0.35),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ),
      );
    }

    String releaseMeta = 'Version Android';
    if (release != null) {
      String dateStr = 'Dernière version';
      if (release.publishedAt != null) {
        try {
          dateStr =
              DateFormat('d MMMM yyyy', 'fr_FR').format(release.publishedAt!);
        } catch (_) {
          final d = release.publishedAt!;
          dateStr = '${d.day}/${d.month}/${d.year}';
        }
      }
      releaseMeta = 'v${release.versionName} • $dateStr';
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => _launchDownload(context, release),
            child: AnimatedScale(
              scale: _isHovered ? 1.025 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutCubic,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFFFCF9F5),
                      Color(0xFFEDE4D7),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: _isHovered ? 1.0 : 0.95),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.45),
                      blurRadius: _isHovered ? 34 : 28,
                      offset: Offset(0, _isHovered ? 12 : 10),
                    ),
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: _isHovered ? 0.50 : 0.35),
                      blurRadius: _isHovered ? 30 : 24,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0B1124).withValues(alpha: 0.08),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.download_rounded,
                        color: Color(0xFF0B1124),
                        size: 26,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text(
                          'Application mobile',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: Color(0xFF55607C),
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.3,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          'Télécharger Ngenou',
                          style: TextStyle(
                            fontSize: 17.5,
                            color: Color(0xFF0B1124),
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                    AnimatedSlide(
                      offset: _isHovered ? const Offset(0, 0.15) : Offset.zero,
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      child: const Icon(
                        Icons.arrow_downward_rounded,
                        color: Color(0xFF0B1124),
                        size: 20,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Text(
            releaseMeta,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
        ),
      ],
    );
  }
}
