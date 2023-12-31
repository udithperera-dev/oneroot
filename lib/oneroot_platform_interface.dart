import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'oneroot_method_channel.dart';

abstract class OnerootPlatform extends PlatformInterface {

  OnerootPlatform() : super(token: _token);

  static final Object _token = Object();

  static OnerootPlatform _instance = MethodChannelOneroot();

  static OnerootPlatform get instance => _instance;

  static set instance(OnerootPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  Future<String?> getRootChecker() {
    throw UnimplementedError('getRootChecker() has not been implemented.');
  }
}
