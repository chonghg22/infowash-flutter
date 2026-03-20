// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'car_wash.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CarWashImpl _$$CarWashImplFromJson(Map<String, dynamic> json) =>
    _$CarWashImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      phone: json['phone'] as String?,
      description: json['description'] as String?,
      facilities:
          (json['facilities'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      thumbnailUrl: json['thumbnailUrl'] as String?,
      isOpen: json['isOpen'] as bool? ?? false,
      operatingHours: json['operatingHours'] as String?,
      bayCount: (json['bayCount'] as num?)?.toInt() ?? 0,
      hasDryer: json['hasDryer'] as bool? ?? false,
      hasVacuum: json['hasVacuum'] as bool? ?? false,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$CarWashImplToJson(_$CarWashImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'rating': instance.rating,
      'reviewCount': instance.reviewCount,
      'phone': instance.phone,
      'description': instance.description,
      'facilities': instance.facilities,
      'thumbnailUrl': instance.thumbnailUrl,
      'isOpen': instance.isOpen,
      'operatingHours': instance.operatingHours,
      'bayCount': instance.bayCount,
      'hasDryer': instance.hasDryer,
      'hasVacuum': instance.hasVacuum,
      'createdAt': instance.createdAt?.toIso8601String(),
    };
