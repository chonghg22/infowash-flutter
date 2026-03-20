// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'review.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReviewImpl _$$ReviewImplFromJson(Map<String, dynamic> json) => _$ReviewImpl(
  id: json['id'] as String,
  carWashId: json['carWashId'] as String,
  userId: json['userId'] as String,
  rating: (json['rating'] as num).toDouble(),
  content: json['content'] as String,
  imageUrls:
      (json['imageUrls'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  userNickname: json['userNickname'] as String?,
  userAvatarUrl: json['userAvatarUrl'] as String?,
  createdAt: json['createdAt'] == null
      ? null
      : DateTime.parse(json['createdAt'] as String),
  updatedAt: json['updatedAt'] == null
      ? null
      : DateTime.parse(json['updatedAt'] as String),
);

Map<String, dynamic> _$$ReviewImplToJson(_$ReviewImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'carWashId': instance.carWashId,
      'userId': instance.userId,
      'rating': instance.rating,
      'content': instance.content,
      'imageUrls': instance.imageUrls,
      'userNickname': instance.userNickname,
      'userAvatarUrl': instance.userAvatarUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
    };
