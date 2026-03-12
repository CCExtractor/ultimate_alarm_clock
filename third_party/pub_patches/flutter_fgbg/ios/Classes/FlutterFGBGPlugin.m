#import "FlutterFGBGPlugin.h"
#if __has_include(<flutter_fgbg/flutter_fgbg-Swift.h>)
#import <flutter_fgbg/flutter_fgbg-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "flutter_fgbg-Swift.h"
#endif

@implementation FlutterFGBGPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterFGBGPlugin registerWithRegistrar:registrar];
}
@end
