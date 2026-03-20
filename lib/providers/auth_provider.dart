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
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.kakao,
        redirectTo: 'io.supabase.infowash://login-callback',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      state = AsyncValue.data(Supabase.instance.client.auth.currentUser);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> signInWithGoogle() async {
    state = const AsyncValue.loading();
    try {
      await Supabase.instance.client.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: 'io.supabase.infowash://login-callback',
        authScreenLaunchMode: LaunchMode.externalApplication,
      );
      state = AsyncValue.data(Supabase.instance.client.auth.currentUser);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
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
