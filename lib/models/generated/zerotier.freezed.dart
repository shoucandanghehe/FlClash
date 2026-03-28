// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../zerotier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ZeroTierConfig {

 bool get enabled; String get networkId; String get planetData;
/// Create a copy of ZeroTierConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZeroTierConfigCopyWith<ZeroTierConfig> get copyWith => _$ZeroTierConfigCopyWithImpl<ZeroTierConfig>(this as ZeroTierConfig, _$identity);

  /// Serializes this ZeroTierConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ZeroTierConfig&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.networkId, networkId) || other.networkId == networkId)&&(identical(other.planetData, planetData) || other.planetData == planetData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,networkId,planetData);

@override
String toString() {
  return 'ZeroTierConfig(enabled: $enabled, networkId: $networkId, planetData: $planetData)';
}


}

/// @nodoc
abstract mixin class $ZeroTierConfigCopyWith<$Res>  {
  factory $ZeroTierConfigCopyWith(ZeroTierConfig value, $Res Function(ZeroTierConfig) _then) = _$ZeroTierConfigCopyWithImpl;
@useResult
$Res call({
 bool enabled, String networkId, String planetData
});




}
/// @nodoc
class _$ZeroTierConfigCopyWithImpl<$Res>
    implements $ZeroTierConfigCopyWith<$Res> {
  _$ZeroTierConfigCopyWithImpl(this._self, this._then);

  final ZeroTierConfig _self;
  final $Res Function(ZeroTierConfig) _then;

/// Create a copy of ZeroTierConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? enabled = null,Object? networkId = null,Object? planetData = null,}) {
  return _then(_self.copyWith(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,networkId: null == networkId ? _self.networkId : networkId // ignore: cast_nullable_to_non_nullable
as String,planetData: null == planetData ? _self.planetData : planetData // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ZeroTierConfig].
extension ZeroTierConfigPatterns on ZeroTierConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ZeroTierConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ZeroTierConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ZeroTierConfig value)  $default,){
final _that = this;
switch (_that) {
case _ZeroTierConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ZeroTierConfig value)?  $default,){
final _that = this;
switch (_that) {
case _ZeroTierConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool enabled,  String networkId,  String planetData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ZeroTierConfig() when $default != null:
return $default(_that.enabled,_that.networkId,_that.planetData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool enabled,  String networkId,  String planetData)  $default,) {final _that = this;
switch (_that) {
case _ZeroTierConfig():
return $default(_that.enabled,_that.networkId,_that.planetData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool enabled,  String networkId,  String planetData)?  $default,) {final _that = this;
switch (_that) {
case _ZeroTierConfig() when $default != null:
return $default(_that.enabled,_that.networkId,_that.planetData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ZeroTierConfig implements ZeroTierConfig {
  const _ZeroTierConfig({this.enabled = false, this.networkId = '', this.planetData = ''});
  factory _ZeroTierConfig.fromJson(Map<String, dynamic> json) => _$ZeroTierConfigFromJson(json);

@override@JsonKey() final  bool enabled;
@override@JsonKey() final  String networkId;
@override@JsonKey() final  String planetData;

/// Create a copy of ZeroTierConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ZeroTierConfigCopyWith<_ZeroTierConfig> get copyWith => __$ZeroTierConfigCopyWithImpl<_ZeroTierConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ZeroTierConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ZeroTierConfig&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.networkId, networkId) || other.networkId == networkId)&&(identical(other.planetData, planetData) || other.planetData == planetData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,enabled,networkId,planetData);

@override
String toString() {
  return 'ZeroTierConfig(enabled: $enabled, networkId: $networkId, planetData: $planetData)';
}


}

/// @nodoc
abstract mixin class _$ZeroTierConfigCopyWith<$Res> implements $ZeroTierConfigCopyWith<$Res> {
  factory _$ZeroTierConfigCopyWith(_ZeroTierConfig value, $Res Function(_ZeroTierConfig) _then) = __$ZeroTierConfigCopyWithImpl;
@override @useResult
$Res call({
 bool enabled, String networkId, String planetData
});




}
/// @nodoc
class __$ZeroTierConfigCopyWithImpl<$Res>
    implements _$ZeroTierConfigCopyWith<$Res> {
  __$ZeroTierConfigCopyWithImpl(this._self, this._then);

  final _ZeroTierConfig _self;
  final $Res Function(_ZeroTierConfig) _then;

/// Create a copy of ZeroTierConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? enabled = null,Object? networkId = null,Object? planetData = null,}) {
  return _then(_ZeroTierConfig(
enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,networkId: null == networkId ? _self.networkId : networkId // ignore: cast_nullable_to_non_nullable
as String,planetData: null == planetData ? _self.planetData : planetData // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ZeroTierStatus {

 bool get online; String get nodeId; String get networkId; List<String> get assignedIps; List<String> get routes; String get subnet;
/// Create a copy of ZeroTierStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ZeroTierStatusCopyWith<ZeroTierStatus> get copyWith => _$ZeroTierStatusCopyWithImpl<ZeroTierStatus>(this as ZeroTierStatus, _$identity);

  /// Serializes this ZeroTierStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ZeroTierStatus&&(identical(other.online, online) || other.online == online)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.networkId, networkId) || other.networkId == networkId)&&const DeepCollectionEquality().equals(other.assignedIps, assignedIps)&&const DeepCollectionEquality().equals(other.routes, routes)&&(identical(other.subnet, subnet) || other.subnet == subnet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,online,nodeId,networkId,const DeepCollectionEquality().hash(assignedIps),const DeepCollectionEquality().hash(routes),subnet);

@override
String toString() {
  return 'ZeroTierStatus(online: $online, nodeId: $nodeId, networkId: $networkId, assignedIps: $assignedIps, routes: $routes, subnet: $subnet)';
}


}

/// @nodoc
abstract mixin class $ZeroTierStatusCopyWith<$Res>  {
  factory $ZeroTierStatusCopyWith(ZeroTierStatus value, $Res Function(ZeroTierStatus) _then) = _$ZeroTierStatusCopyWithImpl;
@useResult
$Res call({
 bool online, String nodeId, String networkId, List<String> assignedIps, List<String> routes, String subnet
});




}
/// @nodoc
class _$ZeroTierStatusCopyWithImpl<$Res>
    implements $ZeroTierStatusCopyWith<$Res> {
  _$ZeroTierStatusCopyWithImpl(this._self, this._then);

  final ZeroTierStatus _self;
  final $Res Function(ZeroTierStatus) _then;

/// Create a copy of ZeroTierStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? online = null,Object? nodeId = null,Object? networkId = null,Object? assignedIps = null,Object? routes = null,Object? subnet = null,}) {
  return _then(_self.copyWith(
online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,networkId: null == networkId ? _self.networkId : networkId // ignore: cast_nullable_to_non_nullable
as String,assignedIps: null == assignedIps ? _self.assignedIps : assignedIps // ignore: cast_nullable_to_non_nullable
as List<String>,routes: null == routes ? _self.routes : routes // ignore: cast_nullable_to_non_nullable
as List<String>,subnet: null == subnet ? _self.subnet : subnet // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ZeroTierStatus].
extension ZeroTierStatusPatterns on ZeroTierStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ZeroTierStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ZeroTierStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ZeroTierStatus value)  $default,){
final _that = this;
switch (_that) {
case _ZeroTierStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ZeroTierStatus value)?  $default,){
final _that = this;
switch (_that) {
case _ZeroTierStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool online,  String nodeId,  String networkId,  List<String> assignedIps,  List<String> routes,  String subnet)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ZeroTierStatus() when $default != null:
return $default(_that.online,_that.nodeId,_that.networkId,_that.assignedIps,_that.routes,_that.subnet);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool online,  String nodeId,  String networkId,  List<String> assignedIps,  List<String> routes,  String subnet)  $default,) {final _that = this;
switch (_that) {
case _ZeroTierStatus():
return $default(_that.online,_that.nodeId,_that.networkId,_that.assignedIps,_that.routes,_that.subnet);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool online,  String nodeId,  String networkId,  List<String> assignedIps,  List<String> routes,  String subnet)?  $default,) {final _that = this;
switch (_that) {
case _ZeroTierStatus() when $default != null:
return $default(_that.online,_that.nodeId,_that.networkId,_that.assignedIps,_that.routes,_that.subnet);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ZeroTierStatus implements ZeroTierStatus {
  const _ZeroTierStatus({this.online = false, this.nodeId = '', this.networkId = '', final  List<String> assignedIps = const [], final  List<String> routes = const [], this.subnet = ''}): _assignedIps = assignedIps,_routes = routes;
  factory _ZeroTierStatus.fromJson(Map<String, dynamic> json) => _$ZeroTierStatusFromJson(json);

@override@JsonKey() final  bool online;
@override@JsonKey() final  String nodeId;
@override@JsonKey() final  String networkId;
 final  List<String> _assignedIps;
@override@JsonKey() List<String> get assignedIps {
  if (_assignedIps is EqualUnmodifiableListView) return _assignedIps;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_assignedIps);
}

 final  List<String> _routes;
@override@JsonKey() List<String> get routes {
  if (_routes is EqualUnmodifiableListView) return _routes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_routes);
}

@override@JsonKey() final  String subnet;

/// Create a copy of ZeroTierStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ZeroTierStatusCopyWith<_ZeroTierStatus> get copyWith => __$ZeroTierStatusCopyWithImpl<_ZeroTierStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ZeroTierStatusToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ZeroTierStatus&&(identical(other.online, online) || other.online == online)&&(identical(other.nodeId, nodeId) || other.nodeId == nodeId)&&(identical(other.networkId, networkId) || other.networkId == networkId)&&const DeepCollectionEquality().equals(other._assignedIps, _assignedIps)&&const DeepCollectionEquality().equals(other._routes, _routes)&&(identical(other.subnet, subnet) || other.subnet == subnet));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,online,nodeId,networkId,const DeepCollectionEquality().hash(_assignedIps),const DeepCollectionEquality().hash(_routes),subnet);

@override
String toString() {
  return 'ZeroTierStatus(online: $online, nodeId: $nodeId, networkId: $networkId, assignedIps: $assignedIps, routes: $routes, subnet: $subnet)';
}


}

/// @nodoc
abstract mixin class _$ZeroTierStatusCopyWith<$Res> implements $ZeroTierStatusCopyWith<$Res> {
  factory _$ZeroTierStatusCopyWith(_ZeroTierStatus value, $Res Function(_ZeroTierStatus) _then) = __$ZeroTierStatusCopyWithImpl;
@override @useResult
$Res call({
 bool online, String nodeId, String networkId, List<String> assignedIps, List<String> routes, String subnet
});




}
/// @nodoc
class __$ZeroTierStatusCopyWithImpl<$Res>
    implements _$ZeroTierStatusCopyWith<$Res> {
  __$ZeroTierStatusCopyWithImpl(this._self, this._then);

  final _ZeroTierStatus _self;
  final $Res Function(_ZeroTierStatus) _then;

/// Create a copy of ZeroTierStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? online = null,Object? nodeId = null,Object? networkId = null,Object? assignedIps = null,Object? routes = null,Object? subnet = null,}) {
  return _then(_ZeroTierStatus(
online: null == online ? _self.online : online // ignore: cast_nullable_to_non_nullable
as bool,nodeId: null == nodeId ? _self.nodeId : nodeId // ignore: cast_nullable_to_non_nullable
as String,networkId: null == networkId ? _self.networkId : networkId // ignore: cast_nullable_to_non_nullable
as String,assignedIps: null == assignedIps ? _self._assignedIps : assignedIps // ignore: cast_nullable_to_non_nullable
as List<String>,routes: null == routes ? _self._routes : routes // ignore: cast_nullable_to_non_nullable
as List<String>,subnet: null == subnet ? _self.subnet : subnet // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
