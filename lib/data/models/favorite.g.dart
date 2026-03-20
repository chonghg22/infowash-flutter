// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoriteImpl _$$FavoriteImplFromJson(Map<String, dynamic> json) =>
    _$FavoriteImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      carWashId: json['carWashId'] as String,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      carWash: json['carWash'] == null
          ? null
          : CarWashSummary.fromJson(json['carWash'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FavoriteImplToJson(_$FavoriteImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'carWashId': instance.carWashId,
      'createdAt': instance.createdAt?.toIso8601String(),
      'carWash': instance.carWash,
    };

_$CarWashSummaryImpl _$$CarWashSummaryImplFromJson(Map<String, dynamic> json) =>
    _$CarWashSummaryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$CarWashSummaryImplToJson(
  _$CarWashSummaryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'images': instance.images,
};
