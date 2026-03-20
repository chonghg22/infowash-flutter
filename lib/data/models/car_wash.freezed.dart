// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'car_wash.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CarWash _$CarWashFromJson(Map<String, dynamic> json) {
  return _CarWash.fromJson(json);
}

/// @nodoc
mixin _$CarWash {
  // ── 기본 정보 ──────────────────────────────────────────────
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  String? get roadAddress =>
      throw _privateConstructorUsedError; // ── 위치 ───────────────────────────────────────────────────
  double get lat => throw _privateConstructorUsedError;
  double get lng =>
      throw _privateConstructorUsedError; // ── 연락처 / 운영 정보 ─────────────────────────────────────
  String? get phone => throw _privateConstructorUsedError;
  String? get openHours => throw _privateConstructorUsedError;
  int get bayCount => throw _privateConstructorUsedError;
  String? get priceInfo =>
      throw _privateConstructorUsedError; // ── 편의시설 ───────────────────────────────────────────────
  bool get hasVacuum => throw _privateConstructorUsedError; // 청소기
  bool get hasAirGun => throw _privateConstructorUsedError; // 에어건
  bool get hasMatWash => throw _privateConstructorUsedError; // 매트세척기
  bool get hasToilet => throw _privateConstructorUsedError; // 화장실
  bool get hasWaiting => throw _privateConstructorUsedError; // 대기 공간
  // ── 이미지 ─────────────────────────────────────────────────
  List<String> get images =>
      throw _privateConstructorUsedError; // ── 메타 ───────────────────────────────────────────────────
  String get source => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  int get reportedCount => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt =>
      throw _privateConstructorUsedError; // ── nearby-carwash Edge Function 응답 추가 필드 ────────────
  double? get distanceM => throw _privateConstructorUsedError;

  /// Serializes this CarWash to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarWash
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarWashCopyWith<CarWash> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarWashCopyWith<$Res> {
  factory $CarWashCopyWith(CarWash value, $Res Function(CarWash) then) =
      _$CarWashCopyWithImpl<$Res, CarWash>;
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    String? roadAddress,
    double lat,
    double lng,
    String? phone,
    String? openHours,
    int bayCount,
    String? priceInfo,
    bool hasVacuum,
    bool hasAirGun,
    bool hasMatWash,
    bool hasToilet,
    bool hasWaiting,
    List<String> images,
    String source,
    String status,
    int reportedCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? distanceM,
  });
}

/// @nodoc
class _$CarWashCopyWithImpl<$Res, $Val extends CarWash>
    implements $CarWashCopyWith<$Res> {
  _$CarWashCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarWash
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? roadAddress = freezed,
    Object? lat = null,
    Object? lng = null,
    Object? phone = freezed,
    Object? openHours = freezed,
    Object? bayCount = null,
    Object? priceInfo = freezed,
    Object? hasVacuum = null,
    Object? hasAirGun = null,
    Object? hasMatWash = null,
    Object? hasToilet = null,
    Object? hasWaiting = null,
    Object? images = null,
    Object? source = null,
    Object? status = null,
    Object? reportedCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? distanceM = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            address: null == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as String,
            roadAddress: freezed == roadAddress
                ? _value.roadAddress
                : roadAddress // ignore: cast_nullable_to_non_nullable
                      as String?,
            lat: null == lat
                ? _value.lat
                : lat // ignore: cast_nullable_to_non_nullable
                      as double,
            lng: null == lng
                ? _value.lng
                : lng // ignore: cast_nullable_to_non_nullable
                      as double,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            openHours: freezed == openHours
                ? _value.openHours
                : openHours // ignore: cast_nullable_to_non_nullable
                      as String?,
            bayCount: null == bayCount
                ? _value.bayCount
                : bayCount // ignore: cast_nullable_to_non_nullable
                      as int,
            priceInfo: freezed == priceInfo
                ? _value.priceInfo
                : priceInfo // ignore: cast_nullable_to_non_nullable
                      as String?,
            hasVacuum: null == hasVacuum
                ? _value.hasVacuum
                : hasVacuum // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasAirGun: null == hasAirGun
                ? _value.hasAirGun
                : hasAirGun // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasMatWash: null == hasMatWash
                ? _value.hasMatWash
                : hasMatWash // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasToilet: null == hasToilet
                ? _value.hasToilet
                : hasToilet // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasWaiting: null == hasWaiting
                ? _value.hasWaiting
                : hasWaiting // ignore: cast_nullable_to_non_nullable
                      as bool,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            source: null == source
                ? _value.source
                : source // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            reportedCount: null == reportedCount
                ? _value.reportedCount
                : reportedCount // ignore: cast_nullable_to_non_nullable
                      as int,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            distanceM: freezed == distanceM
                ? _value.distanceM
                : distanceM // ignore: cast_nullable_to_non_nullable
                      as double?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CarWashImplCopyWith<$Res> implements $CarWashCopyWith<$Res> {
  factory _$$CarWashImplCopyWith(
    _$CarWashImpl value,
    $Res Function(_$CarWashImpl) then,
  ) = __$$CarWashImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    String? roadAddress,
    double lat,
    double lng,
    String? phone,
    String? openHours,
    int bayCount,
    String? priceInfo,
    bool hasVacuum,
    bool hasAirGun,
    bool hasMatWash,
    bool hasToilet,
    bool hasWaiting,
    List<String> images,
    String source,
    String status,
    int reportedCount,
    DateTime? createdAt,
    DateTime? updatedAt,
    double? distanceM,
  });
}

/// @nodoc
class __$$CarWashImplCopyWithImpl<$Res>
    extends _$CarWashCopyWithImpl<$Res, _$CarWashImpl>
    implements _$$CarWashImplCopyWith<$Res> {
  __$$CarWashImplCopyWithImpl(
    _$CarWashImpl _value,
    $Res Function(_$CarWashImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CarWash
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? roadAddress = freezed,
    Object? lat = null,
    Object? lng = null,
    Object? phone = freezed,
    Object? openHours = freezed,
    Object? bayCount = null,
    Object? priceInfo = freezed,
    Object? hasVacuum = null,
    Object? hasAirGun = null,
    Object? hasMatWash = null,
    Object? hasToilet = null,
    Object? hasWaiting = null,
    Object? images = null,
    Object? source = null,
    Object? status = null,
    Object? reportedCount = null,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
    Object? distanceM = freezed,
  }) {
    return _then(
      _$CarWashImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        address: null == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as String,
        roadAddress: freezed == roadAddress
            ? _value.roadAddress
            : roadAddress // ignore: cast_nullable_to_non_nullable
                  as String?,
        lat: null == lat
            ? _value.lat
            : lat // ignore: cast_nullable_to_non_nullable
                  as double,
        lng: null == lng
            ? _value.lng
            : lng // ignore: cast_nullable_to_non_nullable
                  as double,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        openHours: freezed == openHours
            ? _value.openHours
            : openHours // ignore: cast_nullable_to_non_nullable
                  as String?,
        bayCount: null == bayCount
            ? _value.bayCount
            : bayCount // ignore: cast_nullable_to_non_nullable
                  as int,
        priceInfo: freezed == priceInfo
            ? _value.priceInfo
            : priceInfo // ignore: cast_nullable_to_non_nullable
                  as String?,
        hasVacuum: null == hasVacuum
            ? _value.hasVacuum
            : hasVacuum // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasAirGun: null == hasAirGun
            ? _value.hasAirGun
            : hasAirGun // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasMatWash: null == hasMatWash
            ? _value.hasMatWash
            : hasMatWash // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasToilet: null == hasToilet
            ? _value.hasToilet
            : hasToilet // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasWaiting: null == hasWaiting
            ? _value.hasWaiting
            : hasWaiting // ignore: cast_nullable_to_non_nullable
                  as bool,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        source: null == source
            ? _value.source
            : source // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        reportedCount: null == reportedCount
            ? _value.reportedCount
            : reportedCount // ignore: cast_nullable_to_non_nullable
                  as int,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        distanceM: freezed == distanceM
            ? _value.distanceM
            : distanceM // ignore: cast_nullable_to_non_nullable
                  as double?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CarWashImpl implements _CarWash {
  const _$CarWashImpl({
    required this.id,
    required this.name,
    required this.address,
    this.roadAddress,
    required this.lat,
    required this.lng,
    this.phone,
    this.openHours,
    this.bayCount = 0,
    this.priceInfo,
    this.hasVacuum = false,
    this.hasAirGun = false,
    this.hasMatWash = false,
    this.hasToilet = false,
    this.hasWaiting = false,
    final List<String> images = const [],
    this.source = 'USER',
    this.status = 'ACTIVE',
    this.reportedCount = 0,
    this.createdAt,
    this.updatedAt,
    this.distanceM,
  }) : _images = images;

  factory _$CarWashImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarWashImplFromJson(json);

  // ── 기본 정보 ──────────────────────────────────────────────
  @override
  final String id;
  @override
  final String name;
  @override
  final String address;
  @override
  final String? roadAddress;
  // ── 위치 ───────────────────────────────────────────────────
  @override
  final double lat;
  @override
  final double lng;
  // ── 연락처 / 운영 정보 ─────────────────────────────────────
  @override
  final String? phone;
  @override
  final String? openHours;
  @override
  @JsonKey()
  final int bayCount;
  @override
  final String? priceInfo;
  // ── 편의시설 ───────────────────────────────────────────────
  @override
  @JsonKey()
  final bool hasVacuum;
  // 청소기
  @override
  @JsonKey()
  final bool hasAirGun;
  // 에어건
  @override
  @JsonKey()
  final bool hasMatWash;
  // 매트세척기
  @override
  @JsonKey()
  final bool hasToilet;
  // 화장실
  @override
  @JsonKey()
  final bool hasWaiting;
  // 대기 공간
  // ── 이미지 ─────────────────────────────────────────────────
  final List<String> _images;
  // 대기 공간
  // ── 이미지 ─────────────────────────────────────────────────
  @override
  @JsonKey()
  List<String> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  // ── 메타 ───────────────────────────────────────────────────
  @override
  @JsonKey()
  final String source;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final int reportedCount;
  @override
  final DateTime? createdAt;
  @override
  final DateTime? updatedAt;
  // ── nearby-carwash Edge Function 응답 추가 필드 ────────────
  @override
  final double? distanceM;

  @override
  String toString() {
    return 'CarWash(id: $id, name: $name, address: $address, roadAddress: $roadAddress, lat: $lat, lng: $lng, phone: $phone, openHours: $openHours, bayCount: $bayCount, priceInfo: $priceInfo, hasVacuum: $hasVacuum, hasAirGun: $hasAirGun, hasMatWash: $hasMatWash, hasToilet: $hasToilet, hasWaiting: $hasWaiting, images: $images, source: $source, status: $status, reportedCount: $reportedCount, createdAt: $createdAt, updatedAt: $updatedAt, distanceM: $distanceM)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarWashImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.roadAddress, roadAddress) ||
                other.roadAddress == roadAddress) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.openHours, openHours) ||
                other.openHours == openHours) &&
            (identical(other.bayCount, bayCount) ||
                other.bayCount == bayCount) &&
            (identical(other.priceInfo, priceInfo) ||
                other.priceInfo == priceInfo) &&
            (identical(other.hasVacuum, hasVacuum) ||
                other.hasVacuum == hasVacuum) &&
            (identical(other.hasAirGun, hasAirGun) ||
                other.hasAirGun == hasAirGun) &&
            (identical(other.hasMatWash, hasMatWash) ||
                other.hasMatWash == hasMatWash) &&
            (identical(other.hasToilet, hasToilet) ||
                other.hasToilet == hasToilet) &&
            (identical(other.hasWaiting, hasWaiting) ||
                other.hasWaiting == hasWaiting) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reportedCount, reportedCount) ||
                other.reportedCount == reportedCount) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.distanceM, distanceM) ||
                other.distanceM == distanceM));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    name,
    address,
    roadAddress,
    lat,
    lng,
    phone,
    openHours,
    bayCount,
    priceInfo,
    hasVacuum,
    hasAirGun,
    hasMatWash,
    hasToilet,
    hasWaiting,
    const DeepCollectionEquality().hash(_images),
    source,
    status,
    reportedCount,
    createdAt,
    updatedAt,
    distanceM,
  ]);

  /// Create a copy of CarWash
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarWashImplCopyWith<_$CarWashImpl> get copyWith =>
      __$$CarWashImplCopyWithImpl<_$CarWashImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CarWashImplToJson(this);
  }
}

abstract class _CarWash implements CarWash {
  const factory _CarWash({
    required final String id,
    required final String name,
    required final String address,
    final String? roadAddress,
    required final double lat,
    required final double lng,
    final String? phone,
    final String? openHours,
    final int bayCount,
    final String? priceInfo,
    final bool hasVacuum,
    final bool hasAirGun,
    final bool hasMatWash,
    final bool hasToilet,
    final bool hasWaiting,
    final List<String> images,
    final String source,
    final String status,
    final int reportedCount,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final double? distanceM,
  }) = _$CarWashImpl;

  factory _CarWash.fromJson(Map<String, dynamic> json) = _$CarWashImpl.fromJson;

  // ── 기본 정보 ──────────────────────────────────────────────
  @override
  String get id;
  @override
  String get name;
  @override
  String get address;
  @override
  String? get roadAddress; // ── 위치 ───────────────────────────────────────────────────
  @override
  double get lat;
  @override
  double get lng; // ── 연락처 / 운영 정보 ─────────────────────────────────────
  @override
  String? get phone;
  @override
  String? get openHours;
  @override
  int get bayCount;
  @override
  String? get priceInfo; // ── 편의시설 ───────────────────────────────────────────────
  @override
  bool get hasVacuum; // 청소기
  @override
  bool get hasAirGun; // 에어건
  @override
  bool get hasMatWash; // 매트세척기
  @override
  bool get hasToilet; // 화장실
  @override
  bool get hasWaiting; // 대기 공간
  // ── 이미지 ─────────────────────────────────────────────────
  @override
  List<String> get images; // ── 메타 ───────────────────────────────────────────────────
  @override
  String get source;
  @override
  String get status;
  @override
  int get reportedCount;
  @override
  DateTime? get createdAt;
  @override
  DateTime? get updatedAt; // ── nearby-carwash Edge Function 응답 추가 필드 ────────────
  @override
  double? get distanceM;

  /// Create a copy of CarWash
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarWashImplCopyWith<_$CarWashImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
