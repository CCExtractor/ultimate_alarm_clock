#import "FlLocationPlugin.h"
#if __has_include(<fl_location/fl_location-Swift.h>)
#import <fl_location/fl_location-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "fl_location-Swift.h"
#endif

@implementation FlLocationPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlLocationPlugin registerWithRegistrar:registrar];
}
@end
