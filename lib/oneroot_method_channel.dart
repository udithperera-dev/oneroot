import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'oneroot_platform_interface.dart';

class MethodChannelOneroot extends OnerootPlatform {
  @visibleForTesting
  final methodChannel = const MethodChannel('oneroot');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  Future<String?> getRootChecker() async {
    final status = await methodChannel.invokeMethod<String>('getRootChecker');
    return status;
  }
}
