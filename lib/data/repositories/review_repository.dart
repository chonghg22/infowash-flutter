import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/review.dart';

class ReviewRepository {
  ReviewRepository(this._client);

  final SupabaseClient _client;

  static const _schema = 'infowash';
  static const _table = 'review';

  /// 세차장 리뷰 목록
  Future<List<Review>> fetchByCarWash(
    String carWashId, {
    int page = 0,
    int pageSize = 20,
  }) async {
    final data = await _client
        .schema(_schema)
        .from(_table)
        .select()
        .eq('car_wash_id', carWashId)
        .order('created_at', ascending: false)
        .range(page * pageSize, (page + 1) * pageSize - 1);

    return (data as List<dynamic>)
        .map((e) => Review.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 리뷰 작성 — 작성자 닉네임 자동 조회 후 포함
  Future<Review> create({
    required String carWashId,
    required String userId,
    required double rating,
    required String content,
    List<String> imageUrls = const [],
  }) async {
    // user_profile에서 닉네임 조회
    String? nickname;
    try {
      final profile = await _client
          .schema(_schema)
          .from('user_profile')
          .select('nickname')
          .eq('id', userId)
          .maybeSingle();
      nickname = profile?['nickname'] as String?;
    } catch (_) {
      // 닉네임 조회 실패 시 null로 진행
    }

    final data = await _client
        .schema(_schema)
        .from(_table)
        .insert({
          'car_wash_id': carWashId,
          'user_id': userId,
          'rating': rating,
          'content': content,
          'image_urls': imageUrls,
          if (nickname != null) 'nickname': nickname,
        })
        .select()
        .single();

    return Review.fromJson(data);
  }

  /// 리뷰 삭제
  Future<void> delete(String reviewId) async {
    await _client.schema(_schema).from(_table).delete().eq('id', reviewId);
  }

  /// 내 리뷰 목록
  Future<List<Review>> fetchByUser(String userId) async {
    final data = await _client
        .schema(_schema)
        .from(_table)
        .select('*, car_wash(name)')
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    return (data as List<dynamic>)
        .map((e) => Review.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
