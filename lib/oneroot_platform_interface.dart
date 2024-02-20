import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'oneroot_method_channel.dart';

/// {@template oneroot_platform}
/// OnerootPlatform is a common interface for MethodChannelOneroot.
/// {@endtemplate}
abstract class OnerootPlatform extends PlatformInterface {
  OnerootPlatform() : super(token: _token);

  static final Object _token = Object();

  static OnerootPlatform _instance = MethodChannelOneroot();

  static OnerootPlatform get instance => _instance;

  ///init
  static set instance(OnerootPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  ///for get exception message if fail fetch os version
  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  ///for get exception message if fail [root] or [jailbreak] detection
  Future<String?> getRootChecker() {
    throw UnimplementedError('getRootChecker() has not been implemented.');
  }
}
