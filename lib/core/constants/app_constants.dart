class AppConstants {
  AppConstants._();

  // ── App Info ──────────────────────────────────────────────────
  static const String appName = '인포워시';
  static const String appVersion = '1.0.0';

  // ── Supabase ──────────────────────────────────────────────────
  static const String supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://YOUR_PROJECT.supabase.co',
  );
  static const String supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'YOUR_ANON_KEY',
  );

  // ── Naver Map ─────────────────────────────────────────────────
  static const String naverMapClientId = String.fromEnvironment(
    'NAVER_MAP_CLIENT_ID',
    defaultValue: 'YOUR_NAVER_MAP_CLIENT_ID',
  );

  // ── Google AdMob ──────────────────────────────────────────────
  static const String admobAppId =
      'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX'; // Android App ID
  static const String admobBannerUnitId =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX'; // Banner Ad Unit

  // ── Navigation Tabs ───────────────────────────────────────────
  // 탭 추가 시 이 목록에만 추가하면 됩니다.
  static const List<NavTabConfig> bottomNavTabs = [
    NavTabConfig(label: '지도', icon: 'map', route: '/home'),
    NavTabConfig(label: '목록', icon: 'list', route: '/list'),
    NavTabConfig(label: '즐겨찾기', icon: 'favorite', route: '/favorite'),
    // TODO v2.0 Market tab
    // NavTabConfig(label: '마켓', icon: 'store', route: '/market'),
  ];

  // ── TODO v2.0 - 토스페이먼츠 ──────────────────────────────────
  // static const String tossClientKey = '';
  // static const String tossSecretKey = '';

  // ── Pagination ────────────────────────────────────────────────
  static const int defaultPageSize = 20;

  // ── Map Defaults ──────────────────────────────────────────────
  static const double defaultLatitude = 37.5665;   // 서울 시청
  static const double defaultLongitude = 126.9780;
  static const double defaultZoomLevel = 12.0;
  static const double searchRadiusKm = 5.0;
}

class NavTabConfig {
  final String label;
  final String icon;
  final String route;

  const NavTabConfig({
    required this.label,
    required this.icon,
    required this.route,
  });
}
