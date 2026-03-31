// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sub_categories_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SubCategoriesState {

 List<SubCategoryModel> get subCategories; SubCategoriesStatus get status; String? get errorMessage;
/// Create a copy of SubCategoriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubCategoriesStateCopyWith<SubCategoriesState> get copyWith => _$SubCategoriesStateCopyWithImpl<SubCategoriesState>(this as SubCategoriesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SubCategoriesState&&const DeepCollectionEquality().equals(other.subCategories, subCategories)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(subCategories),status,errorMessage);

@override
String toString() {
  return 'SubCategoriesState(subCategories: $subCategories, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $SubCategoriesStateCopyWith<$Res>  {
  factory $SubCategoriesStateCopyWith(SubCategoriesState value, $Res Function(SubCategoriesState) _then) = _$SubCategoriesStateCopyWithImpl;
@useResult
$Res call({
 List<SubCategoryModel> subCategories, SubCategoriesStatus status, String? errorMessage
});




}
/// @nodoc
class _$SubCategoriesStateCopyWithImpl<$Res>
    implements $SubCategoriesStateCopyWith<$Res> {
  _$SubCategoriesStateCopyWithImpl(this._self, this._then);

  final SubCategoriesState _self;
  final $Res Function(SubCategoriesState) _then;

/// Create a copy of SubCategoriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? subCategories = null,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
subCategories: null == subCategories ? _self.subCategories : subCategories // ignore: cast_nullable_to_non_nullable
as List<SubCategoryModel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubCategoriesStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [SubCategoriesState].
extension SubCategoriesStatePatterns on SubCategoriesState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SubCategoriesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SubCategoriesState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SubCategoriesState value)  $default,){
final _that = this;
switch (_that) {
case _SubCategoriesState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SubCategoriesState value)?  $default,){
final _that = this;
switch (_that) {
case _SubCategoriesState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<SubCategoryModel> subCategories,  SubCategoriesStatus status,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SubCategoriesState() when $default != null:
return $default(_that.subCategories,_that.status,_that.errorMessage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<SubCategoryModel> subCategories,  SubCategoriesStatus status,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _SubCategoriesState():
return $default(_that.subCategories,_that.status,_that.errorMessage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<SubCategoryModel> subCategories,  SubCategoriesStatus status,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _SubCategoriesState() when $default != null:
return $default(_that.subCategories,_that.status,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _SubCategoriesState implements SubCategoriesState {
  const _SubCategoriesState({final  List<SubCategoryModel> subCategories = const [], this.status = SubCategoriesStatus.initial, this.errorMessage}): _subCategories = subCategories;
  

 final  List<SubCategoryModel> _subCategories;
@override@JsonKey() List<SubCategoryModel> get subCategories {
  if (_subCategories is EqualUnmodifiableListView) return _subCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_subCategories);
}

@override@JsonKey() final  SubCategoriesStatus status;
@override final  String? errorMessage;

/// Create a copy of SubCategoriesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubCategoriesStateCopyWith<_SubCategoriesState> get copyWith => __$SubCategoriesStateCopyWithImpl<_SubCategoriesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SubCategoriesState&&const DeepCollectionEquality().equals(other._subCategories, _subCategories)&&(identical(other.status, status) || other.status == status)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_subCategories),status,errorMessage);

@override
String toString() {
  return 'SubCategoriesState(subCategories: $subCategories, status: $status, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$SubCategoriesStateCopyWith<$Res> implements $SubCategoriesStateCopyWith<$Res> {
  factory _$SubCategoriesStateCopyWith(_SubCategoriesState value, $Res Function(_SubCategoriesState) _then) = __$SubCategoriesStateCopyWithImpl;
@override @useResult
$Res call({
 List<SubCategoryModel> subCategories, SubCategoriesStatus status, String? errorMessage
});




}
/// @nodoc
class __$SubCategoriesStateCopyWithImpl<$Res>
    implements _$SubCategoriesStateCopyWith<$Res> {
  __$SubCategoriesStateCopyWithImpl(this._self, this._then);

  final _SubCategoriesState _self;
  final $Res Function(_SubCategoriesState) _then;

/// Create a copy of SubCategoriesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? subCategories = null,Object? status = null,Object? errorMessage = freezed,}) {
  return _then(_SubCategoriesState(
subCategories: null == subCategories ? _self._subCategories : subCategories // ignore: cast_nullable_to_non_nullable
as List<SubCategoryModel>,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubCategoriesStatus,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
