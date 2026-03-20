import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_wash.freezed.dart';
part 'car_wash.g.dart';

@freezed
class CarWash with _$CarWash {
  const factory CarWash({
    required String id,
    required String name,
    required String address,
    required double latitude,
    required double longitude,
    @Default(0.0) double rating,
    @Default(0) int reviewCount,
    String? phone,
    String? description,
    @Default([]) List<String> facilities,
    String? thumbnailUrl,
    @Default(false) bool isOpen,
    String? operatingHours,
    @Default(0) int bayCount,        // 세차 베이 수
    @Default(false) bool hasDryer,   // 건조기 보유 여부
    @Default(false) bool hasVacuum,  // 청소기 보유 여부
    DateTime? createdAt,
  }) = _CarWash;

  factory CarWash.fromJson(Map<String, dynamic> json) =>
      _$CarWashFromJson(json);
}
