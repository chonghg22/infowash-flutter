import 'package:freezed_annotation/freezed_annotation.dart';

part 'car_wash.freezed.dart';
part 'car_wash.g.dart';

@freezed
class CarWash with _$CarWash {
  const factory CarWash({
    // ── 기본 정보 ──────────────────────────────────────────────
    required String id,
    required String name,
    required String address,
    String? roadAddress,

    // ── 위치 ───────────────────────────────────────────────────
    required double lat,
    required double lng,

    // ── 연락처 / 운영 정보 ─────────────────────────────────────
    String? phone,
    String? openHours,
    @Default(0) int bayCount,
    String? priceInfo,

    // ── 편의시설 ───────────────────────────────────────────────
    @Default(false) bool hasVacuum,    // 청소기
    @Default(false) bool hasAirGun,   // 에어건
    @Default(false) bool hasMatWash,  // 매트세척기
    @Default(false) bool hasToilet,   // 화장실
    @Default(false) bool hasWaiting,  // 대기 공간

    // ── 이미지 ─────────────────────────────────────────────────
    @Default([]) List<String> images,

    // ── 메타 ───────────────────────────────────────────────────
    @Default('USER') String source,
    @Default('ACTIVE') String status,
    @Default(0) int reportedCount,
    DateTime? createdAt,
    DateTime? updatedAt,

    // ── nearby-carwash Edge Function 응답 추가 필드 ────────────
    double? distanceM,  // 요청 위치로부터의 거리(미터)
  }) = _CarWash;

  factory CarWash.fromJson(Map<String, dynamic> json) =>
      _$CarWashFromJson(json);
}
