// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../zerotier.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ZeroTierConfig _$ZeroTierConfigFromJson(Map<String, dynamic> json) =>
    _ZeroTierConfig(
      enabled: json['enabled'] as bool? ?? false,
      networkId: json['networkId'] as String? ?? '',
      planetData: json['planetData'] as String? ?? '',
    );

Map<String, dynamic> _$ZeroTierConfigToJson(_ZeroTierConfig instance) =>
    <String, dynamic>{
      'enabled': instance.enabled,
      'networkId': instance.networkId,
      'planetData': instance.planetData,
    };

_ZeroTierStatus _$ZeroTierStatusFromJson(Map<String, dynamic> json) =>
    _ZeroTierStatus(
      online: json['online'] as bool? ?? false,
      nodeId: json['nodeId'] as String? ?? '',
      networkId: json['networkId'] as String? ?? '',
      assignedIps:
          (json['assignedIps'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      routes:
          (json['routes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      subnet: json['subnet'] as String? ?? '',
    );

Map<String, dynamic> _$ZeroTierStatusToJson(_ZeroTierStatus instance) =>
    <String, dynamic>{
      'online': instance.online,
      'nodeId': instance.nodeId,
      'networkId': instance.networkId,
      'assignedIps': instance.assignedIps,
      'routes': instance.routes,
      'subnet': instance.subnet,
    };
