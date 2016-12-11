#import "DomSettings.h"

@interface DomSettings (Private)
- (void)_prefsChanged;
@end

static void prefsChanged() {
  CFPreferencesAppSynchronize(CFSTR("com.shade.domum"));
  [[DomSettings sharedSettings] _prefsChanged];
}

@implementation DomSettings

+ (id)sharedSettings {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (id)init {
  if((self = [super init])) {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
		                        NULL,
		                        (CFNotificationCallback)prefsChanged,
		                        CFSTR("com.shade.domum/ReloadPrefs"),
		                        NULL,
		                        CFNotificationSuspensionBehaviorDeliverImmediately);
    [self _prefsChanged];
  }
  return self;
}

- (void)_prefsChanged {
  CFPreferencesAppSynchronize(CFSTR("com.shade.domum"));
	_inLockScreen = !CFPreferencesCopyAppValue(CFSTR("inls"), CFSTR("com.shade.domum")) ? YES : [(__bridge id)CFPreferencesCopyAppValue(CFSTR("inls"), CFSTR("com.shade.domum")) boolValue];
	_opacity = !CFPreferencesCopyAppValue(CFSTR("opacity"), CFSTR("com.shade.domum")) ? 1 : [(__bridge id)CFPreferencesCopyAppValue(CFSTR("opacity"), CFSTR("com.shade.domum")) floatValue];
  _size = !CFPreferencesCopyAppValue(CFSTR("size"), CFSTR("com.shade.domum")) ? 51 : [(__bridge id)CFPreferencesCopyAppValue(CFSTR("size"), CFSTR("com.shade.domum")) floatValue];
}

@end
