import 'package:freezed_annotation/freezed_annotation.dart';

part 'favorite.freezed.dart';
part 'favorite.g.dart';

@freezed
class Favorite with _$Favorite {
  const factory Favorite({
    required String id,
    required String userId,
    required String carWashId,
    DateTime? createdAt,
    // 조인 데이터 (Supabase select 확장 시 사용)
    CarWashSummary? carWash,
  }) = _Favorite;

  factory Favorite.fromJson(Map<String, dynamic> json) =>
      _$FavoriteFromJson(json);
}

/// infowash.car_wash join 요약 (즐겨찾기 목록용)
@freezed
class CarWashSummary with _$CarWashSummary {
  const factory CarWashSummary({
    required String id,
    required String name,
    required String address,
    @Default([]) List<String> images,
  }) = _CarWashSummary;

  factory CarWashSummary.fromJson(Map<String, dynamic> json) =>
      _$CarWashSummaryFromJson(json);
}
