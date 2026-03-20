import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Supabase 초기화 ────────────────────────────────────────────
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  // ── 네이버 지도 초기화 ─────────────────────────────────────────
  // TODO: flutter_naver_map 연동 시 아래 주석 해제
  // await NaverMapSdk.instance.initialize(
  //   clientId: AppConstants.naverMapClientId,
  //   onAuthFailed: (e) => debugPrint('NaverMap auth failed: $e'),
  // );

  // ── AdMob 초기화 ───────────────────────────────────────────────
  // TODO: google_mobile_ads 연동 시 아래 주석 해제
  // await MobileAds.instance.initialize();

  runApp(
    const ProviderScope(
      child: InfoWashApp(),
    ),
  );
}

class InfoWashApp extends ConsumerWidget {
  const InfoWashApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      // 한국어 로케일 설정
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
    );
  }
}
