import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/router/app_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key, this.onLoginSuccess});

  final VoidCallback? onLoginSuccess;

  void _close(BuildContext context) {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authNotifierProvider);
    final isBottomSheet = Navigator.canPop(context);

    ref.listen(authNotifierProvider, (prev, next) {
      next.whenData((user) {
        if (user != null) {
          if (onLoginSuccess != null) {
            onLoginSuccess!();
            _close(context);
          } else if (isBottomSheet) {
            _close(context);
          } else {
            context.go(AppRoutes.home);
          }
        }
      });
    });

    return Scaffold(
      // 바텀시트로 열릴 때는 Scaffold 배경 투명 처리
      backgroundColor: isBottomSheet ? Colors.transparent : null,
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
                isBottomSheet ? '리뷰 작성은 로그인이 필요해요' : '내 주변 셀프세차장을 한눈에',
                style: const TextStyle(color: AppTheme.textSecondary),
              ),

              const Spacer(flex: 2),

              // ── 오류 메시지 ───────────────────────────────
              if (authState is AsyncError)
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    '로그인 중 오류가 발생했습니다.',
                    style: const TextStyle(color: AppTheme.error),
                  ),
                ),

              // ── 카카오 로그인 ─────────────────────────────
              _SocialLoginButton(
                onPressed: authState is AsyncLoading
                    ? null
                    : () => ref
                        .read(authNotifierProvider.notifier)
                        .signInWithKakao(),
                backgroundColor: const Color(0xFFFEE500),
                foregroundColor: const Color(0xFF191919),
                icon: Icons.chat_bubble,
                label: '카카오로 계속하기',
              ),
              const SizedBox(height: 12),

              // ── 구글 로그인 ───────────────────────────────
              _SocialLoginButton(
                onPressed: authState is AsyncLoading
                    ? null
                    : () => ref
                        .read(authNotifierProvider.notifier)
                        .signInWithGoogle(),
                backgroundColor: Colors.white,
                foregroundColor: AppTheme.textPrimary,
                icon: Icons.g_mobiledata,
                label: '구글로 계속하기',
                borderColor: AppTheme.divider,
              ),
              const SizedBox(height: 16),

              // ── 취소 / 비로그인 계속하기 ──────────────────
              TextButton(
                onPressed: () {
                  if (isBottomSheet) {
                    _close(context);
                  } else {
                    context.go(AppRoutes.home);
                  }
                },
                child: Text(
                  isBottomSheet ? '취소' : '로그인 없이 둘러보기',
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

class _SocialLoginButton extends StatelessWidget {
  const _SocialLoginButton({
    required this.onPressed,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.icon,
    required this.label,
    this.borderColor,
  });

  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color foregroundColor;
  final IconData icon;
  final String label;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 22),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: borderColor != null ? 0 : 2,
          side: borderColor != null
              ? BorderSide(color: borderColor!)
              : null,
          textStyle: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
