import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/constants/app_constants.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/nickname_generator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Supabase 초기화 ────────────────────────────────────────────
  // Supabase 대시보드 → Authentication → URL Configuration
  // Redirect URLs에 아래 추가 필요:
  // io.supabase.infowash://login-callback
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
    authOptions: const FlutterAuthClientOptions(
      authFlowType: AuthFlowType.pkce,
    ),
  );

  // ── 로그인 이벤트 직접 리스너 (Riverpod 외부, 타이밍 무관) ────
  Supabase.instance.client.auth.onAuthStateChange.listen((data) async {
    debugPrint('🔐 Auth event: ${data.event}, user: ${data.session?.user.id}');
    if (data.event == AuthChangeEvent.signedIn ||
        data.event == AuthChangeEvent.initialSession) {
      final user = data.session?.user;
      if (user != null) await _ensureProfileInMain(user.id);
    }
  });

  // ── 앱 시작 시 이미 로그인된 유저 프로필 보장 ─────────────────
  final currentUser = Supabase.instance.client.auth.currentUser;
  if (currentUser != null) {
    debugPrint('🔐 앱 시작 시 기존 유저 확인: ${currentUser.id}');
    await _ensureProfileInMain(currentUser.id);
  }

  // ── 딥링크 처리 (카카오 OAuth 콜백) ───────────────────────────
  final appLinks = AppLinks();

  // 앱이 종료된 상태에서 딥링크로 실행된 경우
  final initialUri = await appLinks.getInitialLink();
  if (initialUri != null) {
    debugPrint('🔗 초기 딥링크: $initialUri');
    // 이미 세션이 있으면 중복 처리 방지
    if (Supabase.instance.client.auth.currentUser == null) {
      await Supabase.instance.client.auth.getSessionFromUrl(initialUri);
    }
  }

  // 앱 실행 중 딥링크 수신 (백그라운드 → 포그라운드 복귀)
  appLinks.uriLinkStream.listen((uri) async {
    debugPrint('🔗 딥링크 수신: $uri');
    if (Supabase.instance.client.auth.currentUser == null) {
      await Supabase.instance.client.auth.getSessionFromUrl(uri);
    }
  });

  // ── GPS 워밍업 (위치 권한 있을 때 미리 요청) ──────────────────
  try {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    }
  } catch (_) {}

  // ── 네이버 지도 SDK 초기화 ─────────────────────────────────────
  await FlutterNaverMap().init(
    clientId: AppConstants.naverMapClientId,
    onAuthFailed: (e) => debugPrint('네이버맵 인증 실패: $e'),
  );

  runApp(
    const ProviderScope(
      child: InfoWashApp(),
    ),
  );
}

Future<void> _ensureProfileInMain(String userId) async {
  try {
    final client = Supabase.instance.client;
    final existing = await client
        .schema('infowash')
        .from('user_profile')
        .select('id')
        .eq('id', userId)
        .maybeSingle();

    debugPrint('🔐 기존 프로필: $existing');

    if (existing == null) {
      final nickname = generateNickname();
      await client.schema('infowash').from('user_profile').insert({
        'id': userId,
        'nickname': nickname,
      });
      debugPrint('🔐 닉네임 저장 완료: $nickname');
    }
  } catch (e) {
    debugPrint('🔐 닉네임 생성 에러: $e');
  }
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
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale('ko', 'KR'),
      supportedLocales: const [
        Locale('ko', 'KR'),
        Locale('en', 'US'),
      ],
    );
  }
}
