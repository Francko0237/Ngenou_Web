import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../core/supabase/providers.dart';
import '../features/admin/auth/admin_login_page.dart';
import '../features/admin/dashboard/admin_dashboard_page.dart';
import '../features/admin/release_form/admin_release_form_page.dart';
import '../features/public/confidentialite/confidentialite_page.dart';
import '../features/public/home/home_page.dart';
import '../features/public/nouveautes/nouveautes_page.dart';

/// Provider du routeur GoRouter avec garde d'accès admin
final appRouterProvider = Provider<GoRouter>((ref) {
  final authRepo = ref.watch(authRepositoryProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (BuildContext context, GoRouterState state) async {
      final loc = state.uri.path;
      final isAdminRoute = loc.startsWith('/admin');
      final isLoginPage = loc == '/admin/login';

      if (!isAdminRoute) {
        // Routes publiques : accès libre
        return null;
      }

      final session = authRepo.currentSession;
      final isAuthenticated = session != null;

      if (!isAuthenticated) {
        return isLoginPage ? null : '/admin/login';
      }

      // Vérifier si l'utilisateur est bien admin
      final isAdmin = await authRepo.verifyIsAdmin();

      if (!isAdmin) {
        // Déconnecter et renvoyer sur le login si le rôle n'est pas présent
        await authRepo.signOut();
        return isLoginPage ? null : '/admin/login';
      }

      // Si l'utilisateur est déjà admin et se rend sur la page de login, on le redirige vers le dashboard
      if (isLoginPage) {
        return '/admin';
      }

      return null;
    },
    routes: [
      // Routes publiques avec transitions fluides sans à-coups
      GoRoute(
        path: '/',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const HomePage(),
        ),
      ),
      GoRoute(
        path: '/nouveautes',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const NouveautesPage(),
        ),
      ),
      GoRoute(
        path: '/confidentialite',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const ConfidentialitePage(),
        ),
      ),

      // Routes d'administration
      GoRoute(
        path: '/admin/login',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const AdminLoginPage(),
        ),
      ),
      GoRoute(
        path: '/admin',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const AdminDashboardPage(),
        ),
      ),
      GoRoute(
        path: '/admin/releases/new',
        pageBuilder: (context, state) => _buildFadePage(
          key: state.pageKey,
          child: const AdminReleaseFormPage(),
        ),
      ),
      GoRoute(
        path: '/admin/releases/:id/edit',
        pageBuilder: (context, state) {
          final id = state.pathParameters['id'];
          return _buildFadePage(
            key: state.pageKey,
            child: AdminReleaseFormPage(releaseId: id),
          );
        },
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              '404 - Page introuvable',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Retour à l\'accueil'),
            ),
          ],
        ),
      ),
    ),
  );
});

/// Crée une transition de page par fondu ultra-rapide (200ms) et légère en GPU
CustomTransitionPage<void> _buildFadePage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 200),
    reverseTransitionDuration: const Duration(milliseconds: 150),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        ),
        child: child,
      );
    },
  );
}
