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
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double get latitude => throw _privateConstructorUsedError;
  double get longitude => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  String? get phone => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  List<String> get facilities => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  bool get isOpen => throw _privateConstructorUsedError;
  String? get operatingHours => throw _privateConstructorUsedError;
  int get bayCount => throw _privateConstructorUsedError; // 세차 베이 수
  bool get hasDryer => throw _privateConstructorUsedError; // 건조기 보유 여부
  bool get hasVacuum => throw _privateConstructorUsedError; // 청소기 보유 여부
  DateTime? get createdAt => throw _privateConstructorUsedError;

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
    double latitude,
    double longitude,
    double rating,
    int reviewCount,
    String? phone,
    String? description,
    List<String> facilities,
    String? thumbnailUrl,
    bool isOpen,
    String? operatingHours,
    int bayCount,
    bool hasDryer,
    bool hasVacuum,
    DateTime? createdAt,
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
    Object? latitude = null,
    Object? longitude = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? phone = freezed,
    Object? description = freezed,
    Object? facilities = null,
    Object? thumbnailUrl = freezed,
    Object? isOpen = null,
    Object? operatingHours = freezed,
    Object? bayCount = null,
    Object? hasDryer = null,
    Object? hasVacuum = null,
    Object? createdAt = freezed,
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
            latitude: null == latitude
                ? _value.latitude
                : latitude // ignore: cast_nullable_to_non_nullable
                      as double,
            longitude: null == longitude
                ? _value.longitude
                : longitude // ignore: cast_nullable_to_non_nullable
                      as double,
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            reviewCount: null == reviewCount
                ? _value.reviewCount
                : reviewCount // ignore: cast_nullable_to_non_nullable
                      as int,
            phone: freezed == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            facilities: null == facilities
                ? _value.facilities
                : facilities // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            isOpen: null == isOpen
                ? _value.isOpen
                : isOpen // ignore: cast_nullable_to_non_nullable
                      as bool,
            operatingHours: freezed == operatingHours
                ? _value.operatingHours
                : operatingHours // ignore: cast_nullable_to_non_nullable
                      as String?,
            bayCount: null == bayCount
                ? _value.bayCount
                : bayCount // ignore: cast_nullable_to_non_nullable
                      as int,
            hasDryer: null == hasDryer
                ? _value.hasDryer
                : hasDryer // ignore: cast_nullable_to_non_nullable
                      as bool,
            hasVacuum: null == hasVacuum
                ? _value.hasVacuum
                : hasVacuum // ignore: cast_nullable_to_non_nullable
                      as bool,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
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
    double latitude,
    double longitude,
    double rating,
    int reviewCount,
    String? phone,
    String? description,
    List<String> facilities,
    String? thumbnailUrl,
    bool isOpen,
    String? operatingHours,
    int bayCount,
    bool hasDryer,
    bool hasVacuum,
    DateTime? createdAt,
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
    Object? latitude = null,
    Object? longitude = null,
    Object? rating = null,
    Object? reviewCount = null,
    Object? phone = freezed,
    Object? description = freezed,
    Object? facilities = null,
    Object? thumbnailUrl = freezed,
    Object? isOpen = null,
    Object? operatingHours = freezed,
    Object? bayCount = null,
    Object? hasDryer = null,
    Object? hasVacuum = null,
    Object? createdAt = freezed,
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
        latitude: null == latitude
            ? _value.latitude
            : latitude // ignore: cast_nullable_to_non_nullable
                  as double,
        longitude: null == longitude
            ? _value.longitude
            : longitude // ignore: cast_nullable_to_non_nullable
                  as double,
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        reviewCount: null == reviewCount
            ? _value.reviewCount
            : reviewCount // ignore: cast_nullable_to_non_nullable
                  as int,
        phone: freezed == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        facilities: null == facilities
            ? _value._facilities
            : facilities // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        isOpen: null == isOpen
            ? _value.isOpen
            : isOpen // ignore: cast_nullable_to_non_nullable
                  as bool,
        operatingHours: freezed == operatingHours
            ? _value.operatingHours
            : operatingHours // ignore: cast_nullable_to_non_nullable
                  as String?,
        bayCount: null == bayCount
            ? _value.bayCount
            : bayCount // ignore: cast_nullable_to_non_nullable
                  as int,
        hasDryer: null == hasDryer
            ? _value.hasDryer
            : hasDryer // ignore: cast_nullable_to_non_nullable
                  as bool,
        hasVacuum: null == hasVacuum
            ? _value.hasVacuum
            : hasVacuum // ignore: cast_nullable_to_non_nullable
                  as bool,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
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
    required this.latitude,
    required this.longitude,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.phone,
    this.description,
    final List<String> facilities = const [],
    this.thumbnailUrl,
    this.isOpen = false,
    this.operatingHours,
    this.bayCount = 0,
    this.hasDryer = false,
    this.hasVacuum = false,
    this.createdAt,
  }) : _facilities = facilities;

  factory _$CarWashImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarWashImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String address;
  @override
  final double latitude;
  @override
  final double longitude;
  @override
  @JsonKey()
  final double rating;
  @override
  @JsonKey()
  final int reviewCount;
  @override
  final String? phone;
  @override
  final String? description;
  final List<String> _facilities;
  @override
  @JsonKey()
  List<String> get facilities {
    if (_facilities is EqualUnmodifiableListView) return _facilities;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_facilities);
  }

  @override
  final String? thumbnailUrl;
  @override
  @JsonKey()
  final bool isOpen;
  @override
  final String? operatingHours;
  @override
  @JsonKey()
  final int bayCount;
  // 세차 베이 수
  @override
  @JsonKey()
  final bool hasDryer;
  // 건조기 보유 여부
  @override
  @JsonKey()
  final bool hasVacuum;
  // 청소기 보유 여부
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'CarWash(id: $id, name: $name, address: $address, latitude: $latitude, longitude: $longitude, rating: $rating, reviewCount: $reviewCount, phone: $phone, description: $description, facilities: $facilities, thumbnailUrl: $thumbnailUrl, isOpen: $isOpen, operatingHours: $operatingHours, bayCount: $bayCount, hasDryer: $hasDryer, hasVacuum: $hasVacuum, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarWashImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.latitude, latitude) ||
                other.latitude == latitude) &&
            (identical(other.longitude, longitude) ||
                other.longitude == longitude) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.description, description) ||
                other.description == description) &&
            const DeepCollectionEquality().equals(
              other._facilities,
              _facilities,
            ) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.isOpen, isOpen) || other.isOpen == isOpen) &&
            (identical(other.operatingHours, operatingHours) ||
                other.operatingHours == operatingHours) &&
            (identical(other.bayCount, bayCount) ||
                other.bayCount == bayCount) &&
            (identical(other.hasDryer, hasDryer) ||
                other.hasDryer == hasDryer) &&
            (identical(other.hasVacuum, hasVacuum) ||
                other.hasVacuum == hasVacuum) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    address,
    latitude,
    longitude,
    rating,
    reviewCount,
    phone,
    description,
    const DeepCollectionEquality().hash(_facilities),
    thumbnailUrl,
    isOpen,
    operatingHours,
    bayCount,
    hasDryer,
    hasVacuum,
    createdAt,
  );

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
    required final double latitude,
    required final double longitude,
    final double rating,
    final int reviewCount,
    final String? phone,
    final String? description,
    final List<String> facilities,
    final String? thumbnailUrl,
    final bool isOpen,
    final String? operatingHours,
    final int bayCount,
    final bool hasDryer,
    final bool hasVacuum,
    final DateTime? createdAt,
  }) = _$CarWashImpl;

  factory _CarWash.fromJson(Map<String, dynamic> json) = _$CarWashImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get address;
  @override
  double get latitude;
  @override
  double get longitude;
  @override
  double get rating;
  @override
  int get reviewCount;
  @override
  String? get phone;
  @override
  String? get description;
  @override
  List<String> get facilities;
  @override
  String? get thumbnailUrl;
  @override
  bool get isOpen;
  @override
  String? get operatingHours;
  @override
  int get bayCount; // 세차 베이 수
  @override
  bool get hasDryer; // 건조기 보유 여부
  @override
  bool get hasVacuum; // 청소기 보유 여부
  @override
  DateTime? get createdAt;

  /// Create a copy of CarWash
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarWashImplCopyWith<_$CarWashImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
