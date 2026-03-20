import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../data/repositories/review_repository.dart';
import '../../../core/router/app_router.dart';
import '../../widgets/rating_bar.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key, required this.carWashId});

  final String carWashId;

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  double _rating = 0;
  final _contentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('별점을 선택해주세요.')),
      );
      return;
    }
    if (_contentController.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('리뷰는 10자 이상 입력해주세요.')),
      );
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      context.push(AppRoutes.login);
      return;
    }

    setState(() => _isSubmitting = true);
    try {
      final repo = ReviewRepository(
        ref.read(supabaseClientProvider),
      );
      await repo.create(
        carWashId: widget.carWashId,
        userId: user.id,
        rating: _rating,
        content: _contentController.text.trim(),
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('리뷰가 등록되었습니다.')),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('오류: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('리뷰 작성')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── 별점 선택 ─────────────────────────────────────
            Text('별점', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Center(
              child: InteractiveRatingBar(
                initialRating: _rating,
                size: 40,
                onRatingChanged: (r) => setState(() => _rating = r),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                _rating == 0 ? '별점을 선택하세요' : _ratingLabel(_rating),
                style: const TextStyle(color: AppTheme.textSecondary),
              ),
            ),
            const SizedBox(height: 24),

            // ── 리뷰 내용 ─────────────────────────────────────
            Text('리뷰 내용', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 6,
              maxLength: 500,
              decoration: const InputDecoration(
                hintText: '세차장 이용 후기를 작성해주세요.\n(베이 상태, 청결도, 편의시설 등)',
              ),
            ),
            const SizedBox(height: 24),

            // ── 사진 첨부 (TODO) ──────────────────────────────
            Text('사진 첨부', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () {
                // TODO: 이미지 피커 연동
              },
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  border: Border.all(color: AppTheme.divider),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined,
                        color: AppTheme.textSecondary),
                    SizedBox(height: 4),
                    Text('사진 추가',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppTheme.textSecondary,
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // ── 제출 버튼 ─────────────────────────────────────
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submit,
              child: _isSubmitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Text('리뷰 등록'),
            ),
          ],
        ),
      ),
    );
  }

  String _ratingLabel(double rating) {
    if (rating >= 5) return '최고예요!';
    if (rating >= 4) return '좋아요';
    if (rating >= 3) return '보통이에요';
    if (rating >= 2) return '별로예요';
    return '최악이에요';
  }
}
