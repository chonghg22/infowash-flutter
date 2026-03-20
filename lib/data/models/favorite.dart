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

@freezed
class CarWashSummary with _$CarWashSummary {
  const factory CarWashSummary({
    required String id,
    required String name,
    required String address,
    @Default(0.0) double rating,
    String? thumbnailUrl,
  }) = _CarWashSummary;

  factory CarWashSummary.fromJson(Map<String, dynamic> json) =>
      _$CarWashSummaryFromJson(json);
}
