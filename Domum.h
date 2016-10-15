#include <mach/mach.h>
#include <mach/mach_time.h>
#include <IOKit/hid/IOHIDEvent.h>
#define settingsPath "com.shade.Domum"
#define prefsChanged "com.shade.domum/ReloadPrefs"

@interface SpringBoard

- (void)_menuButtonUp:(struct __IOHIDEvent *)arg1;
- (void)_menuButtonDown:(struct __IOHIDEvent *)arg1;

@end
