import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../localization/app_strings.dart';
import '../theme/app_colors.dart';
import 'responsive_layout.dart';

/// Pied de page du site Ngenou
class SiteFooter extends ConsumerWidget {
  const SiteFooter({super.key});

  Future<void> _openEmail() async {
    final uri = Uri.parse('mailto:ngenou.support@gmail.com');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(appStringsProvider);
    final isMobile = Responsive.isMobile(context);

    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF030712),
        border: Border(
          top: BorderSide(color: AppColors.cardBorder, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: ResponsiveContainer(
        child: Column(
          children: [
            Wrap(
              spacing: 40,
              runSpacing: 32,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.start,
              children: [
                // Colonne 1: Marque
                SizedBox(
                  width: isMobile ? double.infinity : 320,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
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
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.text,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Text(
                        strings.footerBrandDesc,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),

                // Colonne 2: Légal & Conformité
                SizedBox(
                  width: isMobile ? double.infinity : 220,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.footerColLegal,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _FooterLink(
                        title: strings.footerPrivacy,
                        onTap: () => context.go('/confidentialite'),
                      ),
                      _FooterLink(
                        title: strings.footerTerms,
                        onTap: () => context.go('/confidentialite'),
                      ),
                      _FooterLink(
                        title: strings.footerAccountDeletion,
                        onTap: () => context.go('/confidentialite'),
                      ),
                    ],
                  ),
                ),

                // Colonne 3: Développeur & Support
                SizedBox(
                  width: isMobile ? double.infinity : 240,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        strings.footerColDev,
                        style: const TextStyle(
                          color: AppColors.text,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: _openEmail,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            'ngenou.support@gmail.com',
                            style: TextStyle(
                              color: AppColors.cyan,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        strings.footerAuthor,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            const Divider(color: AppColors.cardBorder),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  strings.footerCopyright,
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                ),
                if (!isMobile)
                  Text(
                    strings.footerTagline,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FooterLink extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _FooterLink({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(4),
        child: Text(
          title,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
