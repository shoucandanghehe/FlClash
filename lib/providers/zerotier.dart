import 'package:fl_clash/common/common.dart';
import 'package:fl_clash/models/models.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'generated/zerotier.g.dart';

@Riverpod(keepAlive: true)
class ZeroTierSetting extends _$ZeroTierSetting
    with AutoDisposeNotifierMixin {
  @override
  ZeroTierConfig build() {
    return const ZeroTierConfig();
  }
}

@Riverpod(keepAlive: true)
class ZeroTierState extends _$ZeroTierState with AutoDisposeNotifierMixin {
  @override
  ZeroTierStatus build() {
    return const ZeroTierStatus();
  }
}
