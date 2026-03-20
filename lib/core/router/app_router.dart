import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../presentation/screens/auth/login_screen.dart';
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
      debugPrint('🔐 Auth event: ${data.event}');
      debugPrint('🔐 Session: ${data.session != null ? "exists" : "null"}');
      debugPrint('🔐 User: ${data.session?.user?.id}');

      if (data.event == AuthChangeEvent.signedIn ||
          data.event == AuthChangeEvent.signedOut ||
          data.event == AuthChangeEvent.initialSession ||
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

    redirect: (context, state) {
      // Riverpod StreamProvider 대신 currentUser 직접 체크 (동기, 즉시 반영)
      final user = Supabase.instance.client.auth.currentUser;
      final isLoggedIn = user != null;
      final path = state.matchedLocation;

      debugPrint('🧭 Router redirect - loggedIn: $isLoggedIn, path: $path');

      // /review/* 는 로그인 필요
      if (path.startsWith('/review') && !isLoggedIn) return AppRoutes.login;
      // 로그인 상태에서 /login 페이지 → 홈으로
      if (path == AppRoutes.login && isLoggedIn) return AppRoutes.home;
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
      // redirect는 상단 전역 redirect에서 처리
      GoRoute(
        path: AppRoutes.review,
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
