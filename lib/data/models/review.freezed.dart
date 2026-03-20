// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'review.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Review _$ReviewFromJson(Map<String, dynamic> json) {
  return _Review.fromJson(json);
}

/// @nodoc
mixin _$Review {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'car_wash_id')
  String get carWashId => throw _privateConstructorUsedError;
  @JsonKey(name: 'user_id')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'score_clean')
  int get scoreClean => throw _privateConstructorUsedError;
  @JsonKey(name: 'score_facility')
  int get scoreFacility => throw _privateConstructorUsedError;
  @JsonKey(name: 'score_price')
  int get scorePrice => throw _privateConstructorUsedError;
  String get content => throw _privateConstructorUsedError;
  @JsonKey(name: 'images')
  List<String> get imageUrls => throw _privateConstructorUsedError;
  @JsonKey(name: 'nickname')
  String? get userNickname => throw _privateConstructorUsedError;
  @JsonKey(name: 'created_at')
  DateTime? get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Review to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewCopyWith<Review> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewCopyWith<$Res> {
  factory $ReviewCopyWith(Review value, $Res Function(Review) then) =
      _$ReviewCopyWithImpl<$Res, Review>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'car_wash_id') String carWashId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'score_clean') int scoreClean,
    @JsonKey(name: 'score_facility') int scoreFacility,
    @JsonKey(name: 'score_price') int scorePrice,
    String content,
    @JsonKey(name: 'images') List<String> imageUrls,
    @JsonKey(name: 'nickname') String? userNickname,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class _$ReviewCopyWithImpl<$Res, $Val extends Review>
    implements $ReviewCopyWith<$Res> {
  _$ReviewCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? carWashId = null,
    Object? userId = null,
    Object? scoreClean = null,
    Object? scoreFacility = null,
    Object? scorePrice = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? userNickname = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            carWashId: null == carWashId
                ? _value.carWashId
                : carWashId // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            scoreClean: null == scoreClean
                ? _value.scoreClean
                : scoreClean // ignore: cast_nullable_to_non_nullable
                      as int,
            scoreFacility: null == scoreFacility
                ? _value.scoreFacility
                : scoreFacility // ignore: cast_nullable_to_non_nullable
                      as int,
            scorePrice: null == scorePrice
                ? _value.scorePrice
                : scorePrice // ignore: cast_nullable_to_non_nullable
                      as int,
            content: null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                      as String,
            imageUrls: null == imageUrls
                ? _value.imageUrls
                : imageUrls // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            userNickname: freezed == userNickname
                ? _value.userNickname
                : userNickname // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReviewImplCopyWith<$Res> implements $ReviewCopyWith<$Res> {
  factory _$$ReviewImplCopyWith(
    _$ReviewImpl value,
    $Res Function(_$ReviewImpl) then,
  ) = __$$ReviewImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'car_wash_id') String carWashId,
    @JsonKey(name: 'user_id') String userId,
    @JsonKey(name: 'score_clean') int scoreClean,
    @JsonKey(name: 'score_facility') int scoreFacility,
    @JsonKey(name: 'score_price') int scorePrice,
    String content,
    @JsonKey(name: 'images') List<String> imageUrls,
    @JsonKey(name: 'nickname') String? userNickname,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  });
}

/// @nodoc
class __$$ReviewImplCopyWithImpl<$Res>
    extends _$ReviewCopyWithImpl<$Res, _$ReviewImpl>
    implements _$$ReviewImplCopyWith<$Res> {
  __$$ReviewImplCopyWithImpl(
    _$ReviewImpl _value,
    $Res Function(_$ReviewImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? carWashId = null,
    Object? userId = null,
    Object? scoreClean = null,
    Object? scoreFacility = null,
    Object? scorePrice = null,
    Object? content = null,
    Object? imageUrls = null,
    Object? userNickname = freezed,
    Object? createdAt = freezed,
    Object? updatedAt = freezed,
  }) {
    return _then(
      _$ReviewImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        carWashId: null == carWashId
            ? _value.carWashId
            : carWashId // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        scoreClean: null == scoreClean
            ? _value.scoreClean
            : scoreClean // ignore: cast_nullable_to_non_nullable
                  as int,
        scoreFacility: null == scoreFacility
            ? _value.scoreFacility
            : scoreFacility // ignore: cast_nullable_to_non_nullable
                  as int,
        scorePrice: null == scorePrice
            ? _value.scorePrice
            : scorePrice // ignore: cast_nullable_to_non_nullable
                  as int,
        content: null == content
            ? _value.content
            : content // ignore: cast_nullable_to_non_nullable
                  as String,
        imageUrls: null == imageUrls
            ? _value._imageUrls
            : imageUrls // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        userNickname: freezed == userNickname
            ? _value.userNickname
            : userNickname // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewImpl implements _Review {
  const _$ReviewImpl({
    required this.id,
    @JsonKey(name: 'car_wash_id') required this.carWashId,
    @JsonKey(name: 'user_id') required this.userId,
    @JsonKey(name: 'score_clean') this.scoreClean = 0,
    @JsonKey(name: 'score_facility') this.scoreFacility = 0,
    @JsonKey(name: 'score_price') this.scorePrice = 0,
    this.content = '',
    @JsonKey(name: 'images') final List<String> imageUrls = const [],
    @JsonKey(name: 'nickname') this.userNickname,
    @JsonKey(name: 'created_at') this.createdAt,
    @JsonKey(name: 'updated_at') this.updatedAt,
  }) : _imageUrls = imageUrls;

  factory _$ReviewImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'car_wash_id')
  final String carWashId;
  @override
  @JsonKey(name: 'user_id')
  final String userId;
  @override
  @JsonKey(name: 'score_clean')
  final int scoreClean;
  @override
  @JsonKey(name: 'score_facility')
  final int scoreFacility;
  @override
  @JsonKey(name: 'score_price')
  final int scorePrice;
  @override
  @JsonKey()
  final String content;
  final List<String> _imageUrls;
  @override
  @JsonKey(name: 'images')
  List<String> get imageUrls {
    if (_imageUrls is EqualUnmodifiableListView) return _imageUrls;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_imageUrls);
  }

  @override
  @JsonKey(name: 'nickname')
  final String? userNickname;
  @override
  @JsonKey(name: 'created_at')
  final DateTime? createdAt;
  @override
  @JsonKey(name: 'updated_at')
  final DateTime? updatedAt;

  @override
  String toString() {
    return 'Review(id: $id, carWashId: $carWashId, userId: $userId, scoreClean: $scoreClean, scoreFacility: $scoreFacility, scorePrice: $scorePrice, content: $content, imageUrls: $imageUrls, userNickname: $userNickname, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.carWashId, carWashId) ||
                other.carWashId == carWashId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.scoreClean, scoreClean) ||
                other.scoreClean == scoreClean) &&
            (identical(other.scoreFacility, scoreFacility) ||
                other.scoreFacility == scoreFacility) &&
            (identical(other.scorePrice, scorePrice) ||
                other.scorePrice == scorePrice) &&
            (identical(other.content, content) || other.content == content) &&
            const DeepCollectionEquality().equals(
              other._imageUrls,
              _imageUrls,
            ) &&
            (identical(other.userNickname, userNickname) ||
                other.userNickname == userNickname) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    carWashId,
    userId,
    scoreClean,
    scoreFacility,
    scorePrice,
    content,
    const DeepCollectionEquality().hash(_imageUrls),
    userNickname,
    createdAt,
    updatedAt,
  );

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      __$$ReviewImplCopyWithImpl<_$ReviewImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewImplToJson(this);
  }
}

abstract class _Review implements Review {
  const factory _Review({
    required final String id,
    @JsonKey(name: 'car_wash_id') required final String carWashId,
    @JsonKey(name: 'user_id') required final String userId,
    @JsonKey(name: 'score_clean') final int scoreClean,
    @JsonKey(name: 'score_facility') final int scoreFacility,
    @JsonKey(name: 'score_price') final int scorePrice,
    final String content,
    @JsonKey(name: 'images') final List<String> imageUrls,
    @JsonKey(name: 'nickname') final String? userNickname,
    @JsonKey(name: 'created_at') final DateTime? createdAt,
    @JsonKey(name: 'updated_at') final DateTime? updatedAt,
  }) = _$ReviewImpl;

  factory _Review.fromJson(Map<String, dynamic> json) = _$ReviewImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'car_wash_id')
  String get carWashId;
  @override
  @JsonKey(name: 'user_id')
  String get userId;
  @override
  @JsonKey(name: 'score_clean')
  int get scoreClean;
  @override
  @JsonKey(name: 'score_facility')
  int get scoreFacility;
  @override
  @JsonKey(name: 'score_price')
  int get scorePrice;
  @override
  String get content;
  @override
  @JsonKey(name: 'images')
  List<String> get imageUrls;
  @override
  @JsonKey(name: 'nickname')
  String? get userNickname;
  @override
  @JsonKey(name: 'created_at')
  DateTime? get createdAt;
  @override
  @JsonKey(name: 'updated_at')
  DateTime? get updatedAt;

  /// Create a copy of Review
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewImplCopyWith<_$ReviewImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
