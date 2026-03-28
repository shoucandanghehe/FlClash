// GENERATED CODE - DO NOT MODIFY BY HAND

part of '../zerotier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ZeroTierSetting)
const zeroTierSettingProvider = ZeroTierSettingProvider._();

final class ZeroTierSettingProvider
    extends $NotifierProvider<ZeroTierSetting, ZeroTierConfig> {
  const ZeroTierSettingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zeroTierSettingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zeroTierSettingHash();

  @$internal
  @override
  ZeroTierSetting create() => ZeroTierSetting();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ZeroTierConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ZeroTierConfig>(value),
    );
  }
}

String _$zeroTierSettingHash() => r'dc515b0ad0a9a28c1726dc47fa1d9a062a1f5de2';

abstract class _$ZeroTierSetting extends $Notifier<ZeroTierConfig> {
  ZeroTierConfig build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ZeroTierConfig, ZeroTierConfig>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ZeroTierConfig, ZeroTierConfig>,
              ZeroTierConfig,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ZeroTierState)
const zeroTierStateProvider = ZeroTierStateProvider._();

final class ZeroTierStateProvider
    extends $NotifierProvider<ZeroTierState, ZeroTierStatus> {
  const ZeroTierStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'zeroTierStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$zeroTierStateHash();

  @$internal
  @override
  ZeroTierState create() => ZeroTierState();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ZeroTierStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ZeroTierStatus>(value),
    );
  }
}

String _$zeroTierStateHash() => r'78f130f6d8befea1ae480e7f03fc883b293c4d52';

abstract class _$ZeroTierState extends $Notifier<ZeroTierStatus> {
  ZeroTierStatus build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ZeroTierStatus, ZeroTierStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ZeroTierStatus, ZeroTierStatus>,
              ZeroTierStatus,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
