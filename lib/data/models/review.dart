import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    required String carWashId,
    required String userId,
    required double rating,
    required String content,
    @Default([]) List<String> imageUrls,
    String? userNickname,
    String? userAvatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) =>
      _$ReviewFromJson(json);
}
