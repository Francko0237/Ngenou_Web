import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/app_release.dart';
import '../supabase/providers.dart';
import '../theme/app_colors.dart';

/// Bouton de téléchargement de l'APK Ngenou
class DownloadButton extends ConsumerWidget {
  final bool isCompact;
  final VoidCallback? onDownloaded;

  const DownloadButton({
    super.key,
    this.isCompact = false,
    this.onDownloaded,
  });

  Future<void> _launchDownload(
      BuildContext context, AppRelease? release) async {
    final apkUrl =
        release?.apkUrl?.isNotEmpty == true ? release!.apkUrl! : 'Ngenou.apk';

    final uri = Uri.parse(apkUrl);
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Impossible d\'ouvrir le lien : $apkUrl'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur de téléchargement : $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final latestReleaseAsync = ref.watch(latestReleaseProvider);
    final release = latestReleaseAsync.value;

    if (isCompact) {
      return ElevatedButton.icon(
        onPressed: () => _launchDownload(context, release),
        icon: const Icon(Icons.download_rounded, size: 18),
        label: const Text(
          'Télécharger',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFAF7F2),
          foregroundColor: const Color(0xFF0B1124),
          elevation: 4,
          shadowColor: AppColors.gold.withValues(alpha: 0.35),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
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
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _launchDownload(context, release),
            borderRadius: BorderRadius.circular(999),
            hoverColor: Colors.white.withValues(alpha: 0.1),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 15),
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
                  color: Colors.white.withValues(alpha: 0.95),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.45),
                    blurRadius: 28,
                    offset: const Offset(0, 10),
                  ),
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.35),
                    blurRadius: 24,
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
                  const Icon(
                    Icons.arrow_downward_rounded,
                    color: Color(0xFF0B1124),
                    size: 20,
                  ),
                ],
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
