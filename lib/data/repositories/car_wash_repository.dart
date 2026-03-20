import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/car_wash.dart';

class CarWashRepository {
  CarWashRepository(this._client);

  final SupabaseClient _client;

  // infowash 스키마 기준
  static const _schema = 'infowash';
  static const _table = 'car_wash';

  /// 반경 내 세차장 목록 — nearby-carwash Edge Function 호출
  Future<List<CarWash>> fetchNearby({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
    int limit = 20,
  }) async {
    final response = await _client.functions.invoke(
      'nearby-carwash',
      body: {
        'lat': latitude,
        'lng': longitude,
        'radius_km': radiusKm,
        'limit': limit,
      },
    );

    final data = response.data as List<dynamic>;
    return data
        .map((e) => CarWash.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 전체 목록 (페이지네이션 + 검색)
  Future<List<CarWash>> fetchList({
    int page = 0,
    int pageSize = 20,
    String? searchQuery,
  }) async {
    var query = _client
        .schema(_schema)
        .from(_table)
        .select()
        .eq('status', 'ACTIVE');

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.or(
        'name.ilike.%$searchQuery%,address.ilike.%$searchQuery%',
      );
    }

    final data = await query
        .order('created_at', ascending: false)
        .range(page * pageSize, (page + 1) * pageSize - 1);

    return (data as List<dynamic>)
        .map((e) => CarWash.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 단일 상세 조회
  Future<CarWash?> fetchById(String id) async {
    final data = await _client
        .schema(_schema)
        .from(_table)
        .select()
        .eq('id', id)
        .maybeSingle();

    if (data == null) return null;
    return CarWash.fromJson(data);
  }

  /// 정보 수정 제안 (신고/제보)
  Future<void> reportCorrection({
    required String carWashId,
    required String userId,
    required String content,
  }) async {
    await _client.schema(_schema).from('correction_report').insert({
      'car_wash_id': carWashId,
      'user_id': userId,
      'content': content,
      'status': 'PENDING',
    });
  }
}
