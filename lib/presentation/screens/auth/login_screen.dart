import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key, this.onLoginSuccess});

  final VoidCallback? onLoginSuccess;

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen>
    with WidgetsBindingObserver {
  bool _isBottomSheet = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _isBottomSheet = Navigator.canPop(context);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  // 앱이 포어그라운드로 복귀할 때 — 브라우저 취소 시 로딩 상태 초기화
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(authNotifierProvider.notifier).resetIfNotSignedIn();
    }
  }

  void _close() {
    if (Navigator.canPop(context)) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    // 딥링크 콜백 후 signedIn / initialSession 이벤트 감지 (PKCE 플로우)
    ref.listen<AsyncValue<AuthState>>(authSessionProvider, (_, next) {
      next.whenData((authState) {
        debugPrint('🔑 LoginScreen auth event: ${authState.event}');
        if (authState.event == AuthChangeEvent.signedIn ||
            authState.event == AuthChangeEvent.initialSession) {
          if (widget.onLoginSuccess != null) {
            widget.onLoginSuccess!();
            _close();
          } else if (_isBottomSheet) {
            _close();
          }
          // 전체화면 /login → app_router redirect가 /home으로 처리
        }
      });
    });

    return Scaffold(
      backgroundColor: _isBottomSheet ? Colors.transparent : null,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── 로고 영역 ─────────────────────────────────
              const Icon(
                Icons.local_car_wash,
                size: 80,
                color: AppTheme.primary,
              ),
              const SizedBox(height: 16),
              const Text(
                AppConstants.appName,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: AppTheme.primary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _isBottomSheet ? '리뷰 작성은 로그인이 필요해요' : '내 주변 셀프세차장을 한눈에',
                style: const TextStyle(color: AppTheme.textSecondary),
              ),

              const Spacer(flex: 2),

              // ── 오류 메시지 ───────────────────────────────
              if (authState is AsyncError)
                const Padding(
                  padding: EdgeInsets.only(bottom: 16),
                  child: Text(
                    '로그인 중 오류가 발생했습니다.',
                    style: TextStyle(color: AppTheme.error),
                  ),
                ),

              // ── 카카오 로그인 ─────────────────────────────
              _KakaoLoginButton(
                isLoading: authState is AsyncLoading,
                onPressed: () => ref
                    .read(authNotifierProvider.notifier)
                    .signInWithKakao(),
              ),
              const SizedBox(height: 16),

              // ── 취소 / 비로그인 계속하기 ──────────────────
              TextButton(
                onPressed: () {
                  if (_isBottomSheet) {
                    _close();
                  } else {
                    context.go(AppRoutes.home);
                  }
                },
                child: Text(
                  _isBottomSheet ? '취소' : '로그인 없이 둘러보기',
                  style: const TextStyle(color: AppTheme.textSecondary),
                ),
              ),

              const Spacer(),

              // ── 약관 ─────────────────────────────────────
              const Text(
                '로그인 시 서비스 이용약관 및 개인정보 처리방침에 동의합니다.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: AppTheme.textSecondary),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

/// 바텀시트로 로그인 화면 표시
Future<void> showLoginBottomSheet(
  BuildContext context, {
  VoidCallback? onLoginSuccess,
}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => LoginScreen(onLoginSuccess: onLoginSuccess),
  );
}

class _KakaoLoginButton extends StatelessWidget {
  const _KakaoLoginButton({
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFFEE500),
          foregroundColor: const Color(0xFF191919),
          elevation: 2,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Color(0xFF191919),
                ),
              )
            : const Text('카카오 로그인'),
      ),
    );
  }
}
