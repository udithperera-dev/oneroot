import 'oneroot_platform_interface.dart';

/// {@template method_oneroot}
/// Oneroot is end point for plugin user.
/// {@endtemplate}
class Oneroot {
  ///for get device os version
  Future<String?> getPlatformVersion() {
    return OnerootPlatform.instance.getPlatformVersion();
  }

  ///for get device [root] or [jailbreak] status
  Future<String?> getRootChecker() {
    return OnerootPlatform.instance.getRootChecker();
  }
}
