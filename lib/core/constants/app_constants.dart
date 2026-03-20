class AppConstants {
  AppConstants._();

  // ── App Info ──────────────────────────────────────────────────
  static const String appName = '인포워시';
  static const String appVersion = '1.0.0';

  // ── Supabase ──────────────────────────────────────────────────
  static const String supabaseUrl =
      'REDACTED_SUPABASE_URL';
  static const String supabaseAnonKey =
      'REDACTED_JWT_HEADER'
      'REDACTED_JWT_PAYLOAD'
      'REDACTED_JWT_SIGNATURE';

  // ── Naver Map ─────────────────────────────────────────────────
  static const String naverMapClientId = 'REDACTED_NAVER_CLIENT_ID';

  // ── Google AdMob ──────────────────────────────────────────────
  static const String admobAppId =
      'ca-app-pub-XXXXXXXXXXXXXXXX~XXXXXXXXXX';
  static const String admobBannerUnitId =
      'ca-app-pub-XXXXXXXXXXXXXXXX/XXXXXXXXXX';

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
  static const double defaultLatitude = 37.5665;  // 서울 시청
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
