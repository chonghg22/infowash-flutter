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
      roadAddress: json['roadAddress'] as String?,
      lat: (json['lat'] as num).toDouble(),
      lng: (json['lng'] as num).toDouble(),
      phone: json['phone'] as String?,
      openHours: json['openHours'] as String?,
      bayCount: (json['bayCount'] as num?)?.toInt() ?? 0,
      priceInfo: json['priceInfo'] as String?,
      hasVacuum: json['hasVacuum'] as bool? ?? false,
      hasAirGun: json['hasAirGun'] as bool? ?? false,
      hasMatWash: json['hasMatWash'] as bool? ?? false,
      hasToilet: json['hasToilet'] as bool? ?? false,
      hasWaiting: json['hasWaiting'] as bool? ?? false,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      source: json['source'] as String? ?? 'USER',
      status: json['status'] as String? ?? 'ACTIVE',
      reportedCount: (json['reportedCount'] as num?)?.toInt() ?? 0,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      distanceM: (json['distanceM'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$CarWashImplToJson(_$CarWashImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'roadAddress': instance.roadAddress,
      'lat': instance.lat,
      'lng': instance.lng,
      'phone': instance.phone,
      'openHours': instance.openHours,
      'bayCount': instance.bayCount,
      'priceInfo': instance.priceInfo,
      'hasVacuum': instance.hasVacuum,
      'hasAirGun': instance.hasAirGun,
      'hasMatWash': instance.hasMatWash,
      'hasToilet': instance.hasToilet,
      'hasWaiting': instance.hasWaiting,
      'images': instance.images,
      'source': instance.source,
      'status': instance.status,
      'reportedCount': instance.reportedCount,
      'createdAt': instance.createdAt?.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'distanceM': instance.distanceM,
    };
