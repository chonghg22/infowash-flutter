import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    @JsonKey(name: 'car_wash_id') required String carWashId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'score_clean') @Default(0) int scoreClean,
    @JsonKey(name: 'score_facility') @Default(0) int scoreFacility,
    @JsonKey(name: 'score_price') @Default(0) int scorePrice,
    @Default('') String content,
    @JsonKey(name: 'images') @Default([]) List<String> imageUrls,
    @JsonKey(name: 'nickname') String? userNickname,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);
}
