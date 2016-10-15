#import "Domum.h"
static BOOL enabled;
static CGFloat bleft = ([[UIScreen mainScreen] applicationFrame].size.width/2)-16;
static CGFloat btop = ([[UIScreen mainScreen] applicationFrame].size.height)*0.93;

static void loadPrefs() {
    CFPreferencesAppSynchronize(CFSTR(settingsPath));
    enabled = !CFPreferencesCopyAppValue(CFSTR("Enabled"), CFSTR(settingsPath)) ? YES : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("Enabled"), CFSTR(settingsPath))) boolValue];
}

%hook SBLockScreenViewController
- (void)finishUIUnlockFromSource:(int)arg1 {
  %orig();
  if (enabled) {
		UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(bleft,btop,32,32)];
		UIImage *homeImage = [[UIImage imageNamed:@"/Library/PreferenceBundles/domum.bundle/home32.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIView *view = [[UIView alloc] initWithFrame: [window frame]];

		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:homeImage forState:UIControlStateNormal];
		button.frame = CGRectMake(0,0,32,32);
		button.imageView.tintColor = [UIColor blackColor];
		[button addTarget:self
        action:@selector(home)
        forControlEvents:UIControlEventTouchUpInside];

		window.windowLevel = UIWindowLevelAlert + 1.0;
		[window makeKeyAndVisible];
		[window addSubview: button];
		 [window addSubview: view];
  }
}
%new
-(void)home {
	SpringBoard *springboard = (SpringBoard *)[%c(SpringBoard) sharedApplication];
	uint64_t abTime = mach_absolute_time();
	IOHIDEventRef event = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault, *(AbsoluteTime *)&abTime, 0xC, 0x40, YES, 0);
	[springboard _menuButtonDown:event];
	CFRelease(event);
	event = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault, *(AbsoluteTime *)&abTime, 0xC, 0x40, YES, 0);
	[springboard _menuButtonUp:event];
	CFRelease(event);
}
%end

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    (CFNotificationCallback)loadPrefs,
                                    CFSTR(prefsChanged),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
	loadPrefs();
}
