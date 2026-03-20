// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorite.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Favorite _$FavoriteFromJson(Map<String, dynamic> json) {
  return _Favorite.fromJson(json);
}

/// @nodoc
mixin _$Favorite {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get carWashId => throw _privateConstructorUsedError;
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // 조인 데이터 (Supabase select 확장 시 사용)
  CarWashSummary? get carWash => throw _privateConstructorUsedError;

  /// Serializes this Favorite to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoriteCopyWith<Favorite> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoriteCopyWith<$Res> {
  factory $FavoriteCopyWith(Favorite value, $Res Function(Favorite) then) =
      _$FavoriteCopyWithImpl<$Res, Favorite>;
  @useResult
  $Res call({
    String id,
    String userId,
    String carWashId,
    DateTime? createdAt,
    CarWashSummary? carWash,
  });

  $CarWashSummaryCopyWith<$Res>? get carWash;
}

/// @nodoc
class _$FavoriteCopyWithImpl<$Res, $Val extends Favorite>
    implements $FavoriteCopyWith<$Res> {
  _$FavoriteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? carWashId = null,
    Object? createdAt = freezed,
    Object? carWash = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            carWashId: null == carWashId
                ? _value.carWashId
                : carWashId // ignore: cast_nullable_to_non_nullable
                      as String,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            carWash: freezed == carWash
                ? _value.carWash
                : carWash // ignore: cast_nullable_to_non_nullable
                      as CarWashSummary?,
          )
          as $Val,
    );
  }

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CarWashSummaryCopyWith<$Res>? get carWash {
    if (_value.carWash == null) {
      return null;
    }

    return $CarWashSummaryCopyWith<$Res>(_value.carWash!, (value) {
      return _then(_value.copyWith(carWash: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FavoriteImplCopyWith<$Res>
    implements $FavoriteCopyWith<$Res> {
  factory _$$FavoriteImplCopyWith(
    _$FavoriteImpl value,
    $Res Function(_$FavoriteImpl) then,
  ) = __$$FavoriteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String carWashId,
    DateTime? createdAt,
    CarWashSummary? carWash,
  });

  @override
  $CarWashSummaryCopyWith<$Res>? get carWash;
}

/// @nodoc
class __$$FavoriteImplCopyWithImpl<$Res>
    extends _$FavoriteCopyWithImpl<$Res, _$FavoriteImpl>
    implements _$$FavoriteImplCopyWith<$Res> {
  __$$FavoriteImplCopyWithImpl(
    _$FavoriteImpl _value,
    $Res Function(_$FavoriteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? carWashId = null,
    Object? createdAt = freezed,
    Object? carWash = freezed,
  }) {
    return _then(
      _$FavoriteImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        carWashId: null == carWashId
            ? _value.carWashId
            : carWashId // ignore: cast_nullable_to_non_nullable
                  as String,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        carWash: freezed == carWash
            ? _value.carWash
            : carWash // ignore: cast_nullable_to_non_nullable
                  as CarWashSummary?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$FavoriteImpl implements _Favorite {
  const _$FavoriteImpl({
    required this.id,
    required this.userId,
    required this.carWashId,
    this.createdAt,
    this.carWash,
  });

  factory _$FavoriteImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavoriteImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String carWashId;
  @override
  final DateTime? createdAt;
  // 조인 데이터 (Supabase select 확장 시 사용)
  @override
  final CarWashSummary? carWash;

  @override
  String toString() {
    return 'Favorite(id: $id, userId: $userId, carWashId: $carWashId, createdAt: $createdAt, carWash: $carWash)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoriteImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.carWashId, carWashId) ||
                other.carWashId == carWashId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.carWash, carWash) || other.carWash == carWash));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, carWashId, createdAt, carWash);

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoriteImplCopyWith<_$FavoriteImpl> get copyWith =>
      __$$FavoriteImplCopyWithImpl<_$FavoriteImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FavoriteImplToJson(this);
  }
}

abstract class _Favorite implements Favorite {
  const factory _Favorite({
    required final String id,
    required final String userId,
    required final String carWashId,
    final DateTime? createdAt,
    final CarWashSummary? carWash,
  }) = _$FavoriteImpl;

  factory _Favorite.fromJson(Map<String, dynamic> json) =
      _$FavoriteImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get carWashId;
  @override
  DateTime? get createdAt; // 조인 데이터 (Supabase select 확장 시 사용)
  @override
  CarWashSummary? get carWash;

  /// Create a copy of Favorite
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoriteImplCopyWith<_$FavoriteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CarWashSummary _$CarWashSummaryFromJson(Map<String, dynamic> json) {
  return _CarWashSummary.fromJson(json);
}

/// @nodoc
mixin _$CarWashSummary {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get address => throw _privateConstructorUsedError;
  double get rating => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;

  /// Serializes this CarWashSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CarWashSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CarWashSummaryCopyWith<CarWashSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CarWashSummaryCopyWith<$Res> {
  factory $CarWashSummaryCopyWith(
    CarWashSummary value,
    $Res Function(CarWashSummary) then,
  ) = _$CarWashSummaryCopyWithImpl<$Res, CarWashSummary>;
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    double rating,
    String? thumbnailUrl,
  });
}

/// @nodoc
class _$CarWashSummaryCopyWithImpl<$Res, $Val extends CarWashSummary>
    implements $CarWashSummaryCopyWith<$Res> {
  _$CarWashSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CarWashSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? rating = null,
    Object? thumbnailUrl = freezed,
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
            rating: null == rating
                ? _value.rating
                : rating // ignore: cast_nullable_to_non_nullable
                      as double,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CarWashSummaryImplCopyWith<$Res>
    implements $CarWashSummaryCopyWith<$Res> {
  factory _$$CarWashSummaryImplCopyWith(
    _$CarWashSummaryImpl value,
    $Res Function(_$CarWashSummaryImpl) then,
  ) = __$$CarWashSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String address,
    double rating,
    String? thumbnailUrl,
  });
}

/// @nodoc
class __$$CarWashSummaryImplCopyWithImpl<$Res>
    extends _$CarWashSummaryCopyWithImpl<$Res, _$CarWashSummaryImpl>
    implements _$$CarWashSummaryImplCopyWith<$Res> {
  __$$CarWashSummaryImplCopyWithImpl(
    _$CarWashSummaryImpl _value,
    $Res Function(_$CarWashSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CarWashSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? address = null,
    Object? rating = null,
    Object? thumbnailUrl = freezed,
  }) {
    return _then(
      _$CarWashSummaryImpl(
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
        rating: null == rating
            ? _value.rating
            : rating // ignore: cast_nullable_to_non_nullable
                  as double,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CarWashSummaryImpl implements _CarWashSummary {
  const _$CarWashSummaryImpl({
    required this.id,
    required this.name,
    required this.address,
    this.rating = 0.0,
    this.thumbnailUrl,
  });

  factory _$CarWashSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$CarWashSummaryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String address;
  @override
  @JsonKey()
  final double rating;
  @override
  final String? thumbnailUrl;

  @override
  String toString() {
    return 'CarWashSummary(id: $id, name: $name, address: $address, rating: $rating, thumbnailUrl: $thumbnailUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CarWashSummaryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.address, address) || other.address == address) &&
            (identical(other.rating, rating) || other.rating == rating) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, address, rating, thumbnailUrl);

  /// Create a copy of CarWashSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CarWashSummaryImplCopyWith<_$CarWashSummaryImpl> get copyWith =>
      __$$CarWashSummaryImplCopyWithImpl<_$CarWashSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$CarWashSummaryImplToJson(this);
  }
}

abstract class _CarWashSummary implements CarWashSummary {
  const factory _CarWashSummary({
    required final String id,
    required final String name,
    required final String address,
    final double rating,
    final String? thumbnailUrl,
  }) = _$CarWashSummaryImpl;

  factory _CarWashSummary.fromJson(Map<String, dynamic> json) =
      _$CarWashSummaryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get address;
  @override
  double get rating;
  @override
  String? get thumbnailUrl;

  /// Create a copy of CarWashSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CarWashSummaryImplCopyWith<_$CarWashSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
