import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

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

  // TODO v2.0 Market routes
  // static const market = '/market';
  // static const marketProduct = '/market/product/:id';
  // static const marketCart = '/market/cart';
  // static const marketOrder = '/market/order';
  // static const marketSellerApply = '/market/seller/apply';
  // static const marketSellerDashboard = '/market/seller/dashboard';

  static String detailPath(String id) => '/detail/$id';
  static String reviewPath(String id) => '/review/$id';
}

// ── Provider ──────────────────────────────────────────────────────────────────
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
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

      // Review (full-screen, no bottom nav)
      GoRoute(
        path: AppRoutes.review,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return ReviewScreen(carWashId: id);
        },
      ),

      // Report (full-screen, no bottom nav)
      GoRoute(
        path: AppRoutes.report,
        builder: (context, state) => const ReportScreen(),
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

          // TODO v2.0 Market routes (ShellRoute 내부에 추가)
          // GoRoute(
          //   path: AppRoutes.market,
          //   builder: (context, state) => const MarketScreen(),
          // ),
          // GoRoute(
          //   path: AppRoutes.marketCart,
          //   builder: (context, state) => const CartScreen(),
          // ),
        ],
      ),

      // TODO v2.0 Market full-screen routes (ShellRoute 외부에 추가)
      // GoRoute(
      //   path: AppRoutes.marketProduct,
      //   builder: (context, state) {
      //     final id = state.pathParameters['id']!;
      //     return ProductDetailScreen(id: id);
      //   },
      // ),
      // GoRoute(
      //   path: AppRoutes.marketOrder,
      //   builder: (context, state) => const OrderScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.marketSellerApply,
      //   builder: (context, state) => const SellerApplyScreen(),
      // ),
      // GoRoute(
      //   path: AppRoutes.marketSellerDashboard,
      //   builder: (context, state) => const SellerDashboardScreen(),
      // ),
    ],

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('페이지를 찾을 수 없습니다.\n${state.error}'),
      ),
    ),
  );
});
