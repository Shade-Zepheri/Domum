#include <mach/mach.h>
#include <mach/mach_time.h>
#include <IOKit/hid/IOHIDEvent.h>
#import <UIKit/UIWindow+Private.h>
#import <libactivator/libactivator.h>
#define prefsPath @"/User/Library/Preferences/com.shade.domum.plist"

@interface SpringBoard

- (void)_menuButtonUp:(struct __IOHIDEvent *)arg1;
- (void)_menuButtonDown:(struct __IOHIDEvent *)arg1;

@end

@interface Domum : NSObject <LAListener>
@end
