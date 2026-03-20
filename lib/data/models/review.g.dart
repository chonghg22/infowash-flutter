// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
  id: json['id'] as String,
  carWashId: json['car_wash_id'] as String,
  userId: json['user_id'] as String,
  scoreClean: (json['score_clean'] as num?)?.toInt() ?? 0,
  scoreFacility: (json['score_facility'] as num?)?.toInt() ?? 0,
  scorePrice: (json['score_price'] as num?)?.toInt() ?? 0,
  content: json['content'] as String? ?? '',
  imageUrls:
      (json['images'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  userNickname: json['nickname'] as String?,
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
);

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'car_wash_id': instance.carWashId,
      'user_id': instance.userId,
      'score_clean': instance.scoreClean,
      'score_facility': instance.scoreFacility,
      'score_price': instance.scorePrice,
      'content': instance.content,
      'images': instance.imageUrls,
      'nickname': instance.userNickname,
      'created_at': instance.createdAt?.toIso8601String(),
      'updated_at': instance.updatedAt?.toIso8601String(),
    };
