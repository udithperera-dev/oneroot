#import "OnerootPlugin.h"
#if __has_include(<oneroot/oneroot-Swift.h>)
#import <oneroot/oneroot-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "oneroot-Swift.h"
#endif

@implementation OnerootPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftOnerootPlugin registerWithRegistrar:registrar];
}
@end
