import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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
        redirectTo: 'com.infowash.app://login-callback',
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
        redirectTo: 'com.infowash.app://login-callback',
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
