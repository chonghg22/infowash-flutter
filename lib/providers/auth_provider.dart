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
      if (authState.event == AuthChangeEvent.signedIn) {
        final user = authState.session?.user;
        if (user != null) _ensureUserProfile(user.id);
      }
    });
  });
});

Future<void> _ensureUserProfile(String userId) async {
  try {
    final client = Supabase.instance.client;
    final existing = await client
        .schema('infowash')
        .from('user_profile')
        .select('id')
        .eq('id', userId)
        .maybeSingle();

    if (existing == null) {
      final nickname = generateNickname();
      await client.schema('infowash').from('user_profile').insert({
        'id': userId,
        'nickname': nickname,
      });
    }
  } catch (_) {
    // 프로필 생성 실패는 무시 — 다음 로그인 시 재시도
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
      // authScreenLaunchMode 미지정 → 플랫폼 기본값(Android: Custom Tabs)
      // Custom Tabs는 커스텀 스킴 딥링크 리다이렉트를 더 안정적으로 처리함
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.kakao,
        redirectTo: 'io.supabase.infowash://login-callback',
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
