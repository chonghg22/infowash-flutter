import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/car_wash.dart';

class CarWashRepository {
  CarWashRepository(this._client);

  final SupabaseClient _client;

  static const _table = 'car_washes';

  /// 반경 내 세차장 목록 조회 (PostGIS RPC 사용 예시)
  Future<List<CarWash>> fetchNearby({
    required double latitude,
    required double longitude,
    double radiusKm = 5.0,
  }) async {
    final data = await _client.rpc('nearby_car_washes', params: {
      'lat': latitude,
      'lng': longitude,
      'radius_km': radiusKm,
    }) as List<dynamic>;

    return data
        .map((e) => CarWash.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 전체 목록 (페이지네이션)
  Future<List<CarWash>> fetchList({
    int page = 0,
    int pageSize = 20,
    String? searchQuery,
  }) async {
    var query = _client.from(_table).select();

    if (searchQuery != null && searchQuery.isNotEmpty) {
      query = query.ilike('name', '%$searchQuery%');
    }

    final data = await query
        .order('rating', ascending: false)
        .range(page * pageSize, (page + 1) * pageSize - 1);

    return (data as List<dynamic>)
        .map((e) => CarWash.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 단일 상세 조회
  Future<CarWash?> fetchById(String id) async {
    final data = await _client
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
    await _client.from('correction_reports').insert({
      'car_wash_id': carWashId,
      'user_id': userId,
      'content': content,
      'status': 'pending',
    });
  }
}
