import Flutter
import UIKit

public class OnerootPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "oneroot", binaryMessenger: registrar.messenger())
    let instance = OnerootPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "getRootChecker":
       result(""+OneRoot.isJailbroken)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
