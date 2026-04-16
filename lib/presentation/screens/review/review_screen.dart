import 'dart:io';

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/theme/app_theme.dart';
import '../../../providers/auth_provider.dart';
import '../../../data/repositories/review_repository.dart';
import '../../widgets/rating_bar.dart';

class ReviewScreen extends ConsumerStatefulWidget {
  const ReviewScreen({super.key, required this.carWashId});

  final String carWashId;

  @override
  ConsumerState<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends ConsumerState<ReviewScreen> {
  int _scoreClean = 0;
  int _scoreFacility = 0;
  int _scorePrice = 0;
  final _contentController = TextEditingController();
  bool _isSubmitting = false;
  final List<XFile> _selectedImages = [];

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  // ── 이미지 선택 ────────────────────────────────────────────────────────────
  Future<void> _pickImages() async {
    // Android 13+ : READ_MEDIA_IMAGES / 이하 : READ_EXTERNAL_STORAGE
    final status = await Permission.photos.request();

    if (!status.isGranted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('사진 접근 권한이 필요합니다.')),
        );
      }
      return;
    }

    final picker = ImagePicker();
    if (_selectedImages.length >= 2) return;

    final picked = await picker.pickMultiImage(limit: 2);
    if (picked.isNotEmpty) {
      final combined = [..._selectedImages, ...picked];
      if (combined.length > 2) {
        setState(() {
          _selectedImages
            ..clear()
            ..addAll(combined.take(2));
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('이미지는 최대 2장까지 첨부 가능해요')),
          );
        }
      } else {
        setState(() => _selectedImages.addAll(picked));
      }
    }
  }

  // ── Supabase Storage 업로드 ────────────────────────────────────────────────
  Future<List<String>> _uploadImages() async {
    final client = ref.read(supabaseClientProvider);
    final urls = <String>[];

    for (final image in _selectedImages) {
      final bytes = await image.readAsBytes();
      final ext = image.name.split('.').last.toLowerCase();
      final fileName = '${DateTime.now().microsecondsSinceEpoch}.$ext';
      final path = '${widget.carWashId}/$fileName';

      await client.storage
          .from('review-images')
          .uploadBinary(path, bytes,
              fileOptions: FileOptions(contentType: 'image/jpeg'));

      final url =
          client.storage.from('review-images').getPublicUrl(path);
      urls.add(url);
    }
    return urls;
  }

  // ── 제출 ──────────────────────────────────────────────────────────────────
  Future<void> _submit() async {
    if (_scoreClean == 0 || _scoreFacility == 0 || _scorePrice == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('모든 항목의 별점을 선택해주세요.')),
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
    if (user == null) return;

    setState(() => _isSubmitting = true);
    try {
      // 이미지 업로드
      final imageUrls =
          _selectedImages.isNotEmpty ? await _uploadImages() : <String>[];

      final repo = ReviewRepository(ref.read(supabaseClientProvider));
      await repo.create(
        carWashId: widget.carWashId,
        userId: user.id,
        scoreClean: _scoreClean,
        scoreFacility: _scoreFacility,
        scorePrice: _scorePrice,
        content: _contentController.text.trim(),
        imageUrls: imageUrls,
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
            _ScoreRow(
              label: '청결도',
              score: _scoreClean,
              onChanged: (v) => setState(() => _scoreClean = v),
            ),
            const SizedBox(height: 8),
            _ScoreRow(
              label: '시설',
              score: _scoreFacility,
              onChanged: (v) => setState(() => _scoreFacility = v),
            ),
            const SizedBox(height: 8),
            _ScoreRow(
              label: '가격대비',
              score: _scorePrice,
              onChanged: (v) => setState(() => _scorePrice = v),
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

            // ── 사진 첨부 ─────────────────────────────────────
            Text('사진 첨부', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 4),
            Text(
              '최대 2장',
              style: const TextStyle(
                  fontSize: 12, color: AppTheme.textSecondary),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 80,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  // 선택된 이미지 미리보기
                  ..._selectedImages.map((img) => _ImagePreview(
                        image: img,
                        onRemove: () =>
                            setState(() => _selectedImages.remove(img)),
                      )),
                  // 추가 버튼 (최대 2장)
                  if (_selectedImages.length < 2)
                    GestureDetector(
                      onTap: _pickImages,
                      child: Container(
                        width: 80,
                        height: 80,
                        margin: const EdgeInsets.only(right: 8),
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
                ],
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

}

// ── 항목별 별점 행 ────────────────────────────────────────────────────────────
class _ScoreRow extends StatelessWidget {
  const _ScoreRow({
    required this.label,
    required this.score,
    required this.onChanged,
  });

  final String label;
  final int score;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 64,
          child: Text(label, style: const TextStyle(fontSize: 14)),
        ),
        InteractiveRatingBar(
          initialRating: score.toDouble(),
          size: 28,
          onRatingChanged: (r) => onChanged(r.round()),
        ),
        const SizedBox(width: 8),
        Text(
          score == 0 ? '-' : '$score점',
          style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
      ],
    );
  }
}

// ── 이미지 미리보기 위젯 ──────────────────────────────────────────────────────
class _ImagePreview extends StatelessWidget {
  const _ImagePreview({required this.image, required this.onRemove});

  final XFile image;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 80,
          height: 80,
          margin: const EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: FileImage(File(image.path)),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          top: 2,
          right: 10,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                color: Colors.black54,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
