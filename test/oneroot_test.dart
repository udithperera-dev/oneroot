import 'package:flutter_test/flutter_test.dart';
import 'package:oneroot/oneroot.dart';
import 'package:oneroot/oneroot_platform_interface.dart';
import 'package:oneroot/oneroot_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOnerootPlatform
    with MockPlatformInterfaceMixin
    implements OnerootPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<String?> getRootChecker() {
    throw UnimplementedError();
  }
}

void main() {
  final OnerootPlatform initialPlatform = OnerootPlatform.instance;

  test('$MethodChannelOneroot is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOneroot>());
  });

  test('getPlatformVersion', () async {
    Oneroot onerootPlugin = Oneroot();
    MockOnerootPlatform fakePlatform = MockOnerootPlatform();
    OnerootPlatform.instance = fakePlatform;
    expect(await onerootPlugin.getPlatformVersion(), '42');
  });
}
