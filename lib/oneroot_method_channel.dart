import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'oneroot_platform_interface.dart';

/// {@template method_channel_oneroot}
/// MethodChannelOneroot is derived from OnerootPlatform interface.
/// {@endtemplate}
class MethodChannelOneroot extends OnerootPlatform {
  ///init ther interface channel
  @visibleForTesting
  final methodChannel = const MethodChannel('oneroot');

  ///for get device os version
  @override
  Future<String?> getPlatformVersion() async {
    final version =
        await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  ///for get device [root] or [jailbreak] status
  @override
  Future<String?> getRootChecker() async {
    final status = await methodChannel.invokeMethod<String>('getRootChecker');
    return status;
  }
}
