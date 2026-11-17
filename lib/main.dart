import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/localization/app_strings.dart';
import 'core/supabase/supabase_config.dart';
import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Activer des URLs sans le préfixe '#' pour que /admin et /nouveautes fonctionnent proprement
  usePathUrlStrategy();

  // Initialisation des formats de dates
  try {
    await initializeDateFormatting('fr_FR', null);
    await initializeDateFormatting('en_US', null);
  } catch (_) {}

  // Initialisation de Supabase
  await SupabaseConfig.initialize();

  runApp(
    const ProviderScope(
      child: NgenouWebApp(),
    ),
  );
}

class NgenouWebApp extends ConsumerWidget {
  const NgenouWebApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final strings = ref.watch(appStringsProvider);

    return MaterialApp.router(
      title: strings.appTitle,
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: AppTheme.darkTheme,
      routerConfig: router,
    );
  }
}
