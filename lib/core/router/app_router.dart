import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../presentation/screens/auth/login_screen.dart';
import '../../providers/auth_provider.dart';
import '../../presentation/screens/detail/detail_screen.dart';
import '../../presentation/screens/favorite/favorite_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/list/list_screen.dart';
import '../../presentation/screens/report/report_screen.dart';
import '../../presentation/screens/review/review_screen.dart';
import '../../presentation/screens/splash/splash_screen.dart';
import '../../presentation/widgets/main_shell.dart';

// ── Route paths ───────────────────────────────────────────────────────────────
class AppRoutes {
  AppRoutes._();

  static const splash = '/';
  static const home = '/home';
  static const list = '/list';
  static const detail = '/detail/:id';
  static const login = '/login';
  static const favorite = '/favorite';
  static const report = '/report';
  static const review = '/review/:id';

  static String detailPath(String id) => '/detail/$id';
  static String reviewPath(String id) => '/review/$id';
}

// ── Auth 상태 변화 → GoRouter refresh ─────────────────────────────────────────
class _AuthChangeNotifier extends ChangeNotifier {
  _AuthChangeNotifier() {
    _sub = Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      if (data.event == AuthChangeEvent.signedIn ||
          data.event == AuthChangeEvent.signedOut ||
          data.event == AuthChangeEvent.userUpdated) {
        notifyListeners();
      }
    });
  }

  late final StreamSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

// ── Provider ──────────────────────────────────────────────────────────────────
final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = _AuthChangeNotifier();
  ref.onDispose(authNotifier.dispose);

  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    refreshListenable: authNotifier,

    // 로그인 완료 후 /login에 머물지 않도록 리다이렉트
    redirect: (context, state) {
      final isSignedIn =
          Supabase.instance.client.auth.currentUser != null;
      final isOnLogin =
          state.matchedLocation == AppRoutes.login;

      if (isSignedIn && isOnLogin) return AppRoutes.home;
      return null;
    },

    routes: [
      // Splash
      GoRoute(
        path: AppRoutes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      // Login
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      // Detail (full-screen, no bottom nav)
      GoRoute(
        path: AppRoutes.detail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return DetailScreen(id: id);
        },
      ),

      // Review (full-screen, no bottom nav) — 로그인 필요
      GoRoute(
        path: AppRoutes.review,
        redirect: (context, state) {
          final container =
              ProviderScope.containerOf(context, listen: false);
          if (!container.read(isSignedInProvider)) {
            return AppRoutes.login;
          }
          return null;
        },
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ReviewScreen(carWashId: id);
        },
      ),

      // Report (full-screen, no bottom nav) — 비로그인 허용
      GoRoute(
        path: AppRoutes.report,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          final carWashId = extra?['carWashId'] as String?;
          return ReportScreen(carWashId: carWashId);
        },
      ),

      // Shell: screens with bottom navigation
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: AppRoutes.home,
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppRoutes.list,
            builder: (context, state) => const ListScreen(),
          ),
          GoRoute(
            path: AppRoutes.favorite,
            builder: (context, state) => const FavoriteScreen(),
          ),
        ],
      ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('페이지를 찾을 수 없습니다.\n${state.error}'),
      ),
    ),
  );
});
