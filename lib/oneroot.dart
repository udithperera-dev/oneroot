import 'oneroot_platform_interface.dart';

class Oneroot {
  Future<String?> getPlatformVersion() {
    return OnerootPlatform.instance.getPlatformVersion();
  }

  Future<String?> getRootChecker() {
    return OnerootPlatform.instance.getRootChecker();
  }
}
