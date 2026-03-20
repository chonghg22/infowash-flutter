import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/repositories/car_wash_repository.dart';
import '../../../providers/auth_provider.dart';
import '../../../core/router/app_router.dart';

enum ReportType {
  wrongAddress('주소 오류'),
  wrongPhone('전화번호 오류'),
  wrongHours('영업시간 오류'),
  closed('폐업/이전'),
  other('기타');

  const ReportType(this.label);
  final String label;
}

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key, this.carWashId});

  final String? carWashId;

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  ReportType? _selectedType;
  final _contentController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_selectedType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('신고 유형을 선택해주세요.')),
      );
      return;
    }
    if (_contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('내용을 입력해주세요.')),
      );
      return;
    }

    final user = ref.read(currentUserProvider);
    if (user == null) {
      context.push(AppRoutes.login);
      return;
    }

    if (widget.carWashId == null) return;

    setState(() => _isSubmitting = true);
    try {
      final repo = CarWashRepository(ref.read(supabaseClientProvider));
      await repo.reportCorrection(
        carWashId: widget.carWashId!,
        userId: user.id,
        content: '[${_selectedType!.label}] ${_contentController.text.trim()}',
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('신고가 접수되었습니다. 검토 후 반영됩니다.')),
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
      appBar: AppBar(title: const Text('정보 수정 제안')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 안내 텍스트
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFE3F2FD),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: AppTheme.primary, size: 18),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '잘못된 정보를 알려주시면 검토 후 수정됩니다.\n소중한 제보 감사합니다!',
                      style:
                          TextStyle(fontSize: 13, color: AppTheme.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── 신고 유형 ─────────────────────────────────────
            Text('신고 유형', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: ReportType.values.map((type) {
                final isSelected = _selectedType == type;
                return ChoiceChip(
                  label: Text(type.label),
                  selected: isSelected,
                  selectedColor: AppTheme.primary,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : AppTheme.textPrimary,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                  onSelected: (selected) {
                    if (selected) setState(() => _selectedType = type);
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // ── 상세 내용 ─────────────────────────────────────
            Text('상세 내용', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 5,
              maxLength: 300,
              decoration: const InputDecoration(
                hintText: '올바른 정보나 변경 사항을 입력해주세요.',
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
                  : const Text('제출하기'),
            ),
          ],
        ),
      ),
    );
  }
}
