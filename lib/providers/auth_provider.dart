import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../core/utils/nickname_generator.dart';

// ── Supabase Client ───────────────────────────────────────────────────────────
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// ── 현재 세션 ─────────────────────────────────────────────────────────────────
final authSessionProvider = StreamProvider<AuthState>((ref) {
  return Supabase.instance.client.auth.onAuthStateChange;
});

// ── 현재 User ─────────────────────────────────────────────────────────────────
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authSessionProvider);
  return authState.valueOrNull?.session?.user;
});

// ── 로그인 여부 ───────────────────────────────────────────────────────────────
final isSignedInProvider = Provider<bool>((ref) {
  return ref.watch(currentUserProvider) != null;
});

// ── 사용자 닉네임 ─────────────────────────────────────────────────────────────
final userNicknameProvider = FutureProvider<String?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;

  try {
    final data = await Supabase.instance.client
        .schema('infowash')
        .from('user_profile')
        .select('nickname')
        .eq('id', user.id)
        .maybeSingle();
    return data?['nickname'] as String?;
  } catch (_) {
    return null;
  }
});

// ── 프로필 자동 생성 (로그인 시 신규 유저 닉네임 생성) ────────────────────────
final profileInitProvider = Provider<void>((ref) {
  ref.listen<AsyncValue<AuthState>>(authSessionProvider, (_, next) {
    next.whenData((authState) {
      debugPrint('👤 profileInitProvider event: ${authState.event}');
      // signedIn + initialSession 모두 처리 (PKCE 콜백 시 initialSession 발생 가능)
      if (authState.event == AuthChangeEvent.signedIn ||
          authState.event == AuthChangeEvent.initialSession) {
        final user = authState.session?.user;
        if (user != null) _ensureUserProfile(user.id);
      }
    });
  });
});

Future<void> _ensureUserProfile(String userId) async {
  try {
    final client = Supabase.instance.client;
    debugPrint('👤 _ensureUserProfile: userId=$userId');

    final existing = await client
        .schema('infowash')
        .from('user_profile')
        .select('id')
        .eq('id', userId)
        .maybeSingle();

    debugPrint('👤 기존 프로필: $existing');

    if (existing == null) {
      final nickname = generateNickname();
      debugPrint('👤 생성된 닉네임: $nickname');
      await client.schema('infowash').from('user_profile').insert({
        'id': userId,
        'nickname': nickname,
      });
      debugPrint('👤 닉네임 저장 완료: $nickname');
    }
  } catch (e) {
    debugPrint('👤 닉네임 생성 에러: $e');
  }
}

// ── AuthNotifier ──────────────────────────────────────────────────────────────
class AuthNotifier extends Notifier<AsyncValue<User?>> {
  @override
  AsyncValue<User?> build() {
    final user = Supabase.instance.client.auth.currentUser;
    return AsyncValue.data(user);
  }

  Future<void> signInWithKakao() async {
    state = const AsyncValue.loading();
    try {
      // redirectTo: Supabase가 카카오 인증 처리 완료 후 앱으로 돌아올 딥링크
      // (카카오 → Supabase 콜백은 Supabase가 자동 처리, 별개의 URL)
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.kakao,
        redirectTo: 'io.supabase.infowash://login-callback',
        authScreenLaunchMode: LaunchMode.externalApplication,
        queryParams: {
          'scope': '', // 빈 스코프로 기본 스코프 요청 방지 (KOE205 해결)
        },
      );
      // 브라우저가 열리고 즉시 반환됨 — 실제 로그인 완료는 authSessionProvider가 감지
      // 상태를 즉시 리셋하지 않고 loading 유지 (LoginScreen이 resume 시 리셋)
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// 브라우저에서 복귀했지만 로그인하지 않은 경우 상태 초기화
  void resetIfNotSignedIn() {
    if (state is AsyncLoading) {
      final user = Supabase.instance.client.auth.currentUser;
      state = AsyncValue.data(user);
    }
  }

  Future<void> signOut() async {
    state = const AsyncValue.loading();
    try {
      await Supabase.instance.client.auth.signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AsyncValue<User?>>(() => AuthNotifier());
