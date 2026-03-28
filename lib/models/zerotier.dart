import 'package:freezed_annotation/freezed_annotation.dart';

part 'generated/zerotier.freezed.dart';
part 'generated/zerotier.g.dart';

@freezed
abstract class ZeroTierConfig with _$ZeroTierConfig {
  const factory ZeroTierConfig({
    @Default(false) bool enabled,
    @Default('') String networkId,
    @Default('') String planetData,
  }) = _ZeroTierConfig;

  factory ZeroTierConfig.fromJson(Map<String, dynamic> json) =>
      _$ZeroTierConfigFromJson(json);
}

@freezed
abstract class ZeroTierStatus with _$ZeroTierStatus {
  const factory ZeroTierStatus({
    @Default(false) bool online,
    @Default('') String nodeId,
    @Default('') String networkId,
    @Default([]) List<String> assignedIps,
    @Default([]) List<String> routes,
    @Default('') String subnet,
  }) = _ZeroTierStatus;

  factory ZeroTierStatus.fromJson(Map<String, dynamic> json) =>
      _$ZeroTierStatusFromJson(json);
}
