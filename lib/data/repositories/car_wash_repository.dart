import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/car_wash.dart';
import '../models/review.dart';

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

  /// 전체 세차장 조회 + 클라이언트 거리 계산 및 정렬
  Future<List<CarWash>> getAllCarWashes({
    required double lat,
    required double lng,
  }) async {
    final data = await _client
        .schema(_schema)
        .from(_table)
        .select()
        .eq('status', 'ACTIVE')
        .order('created_at', ascending: false);

    final list = (data as List<dynamic>)
        .map((e) => CarWash.fromJson(e as Map<String, dynamic>))
        .toList();

    final withDistance = list.map((cw) {
      final distM = Geolocator.distanceBetween(lat, lng, cw.lat, cw.lng);
      return cw.copyWith(distanceM: distM);
    }).toList()
      ..sort((a, b) => (a.distanceM ?? double.infinity)
          .compareTo(b.distanceM ?? double.infinity));

    return withDistance;
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

  /// 세차장 리뷰 목록 조회
  Future<List<Review>> getReviews(String carWashId) async {
    final data = await _client
        .schema(_schema)
        .from('review')
        .select()
        .eq('car_wash_id', carWashId)
        .order('created_at', ascending: false)
        .limit(20);

    return (data as List<dynamic>)
        .map((e) => Review.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  /// 즐겨찾기 여부 확인
  Future<bool> isFavorite(String carWashId) async {
    final user = _client.auth.currentUser;
    if (user == null) return false;

    final data = await _client
        .schema(_schema)
        .from('favorite')
        .select('id')
        .eq('car_wash_id', carWashId)
        .eq('user_id', user.id)
        .maybeSingle();

    return data != null;
  }

  /// 즐겨찾기 토글 — 추가 시 true, 제거 시 false 반환
  Future<bool> toggleFavorite(String carWashId) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('로그인이 필요합니다.');

    final exists = await isFavorite(carWashId);
    if (exists) {
      await _client
          .schema(_schema)
          .from('favorite')
          .delete()
          .eq('car_wash_id', carWashId)
          .eq('user_id', user.id);
      return false;
    } else {
      await _client.schema(_schema).from('favorite').insert({
        'car_wash_id': carWashId,
        'user_id': user.id,
      });
      return true;
    }
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
