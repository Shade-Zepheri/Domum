#import "Domum.h"
static BOOL enabled;
UIWindow *window;
UIView *view;
UIButton *button;
static CGFloat bleft = ([[UIScreen mainScreen] applicationFrame].size.width/2)-24;
static CGFloat btop = ([[UIScreen mainScreen] applicationFrame].size.height)*0.9;

static void loadPrefs() {
    CFPreferencesAppSynchronize(CFSTR(settingsPath));
    enabled = !CFPreferencesCopyAppValue(CFSTR("Enabled"), CFSTR(settingsPath)) ? YES : [(id)CFBridgingRelease(CFPreferencesCopyAppValue(CFSTR("Enabled"), CFSTR(settingsPath))) boolValue];
    if(!enabled){
      [button removeFromSuperview];
      [view removeFromSuperview];
    }
}

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg1 {
  %orig();
  if (enabled) {
		window = [[UIWindow alloc] initWithFrame:CGRectMake(bleft,btop,48,48)];
		view = [[UIView alloc] initWithFrame: [window frame]];

		button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:[UIImage imageNamed:@"/Library/PreferenceBundles/domum.bundle/Home.png"] forState:UIControlStateNormal];
		button.frame = CGRectMake(0,0,48,48);
		[button addTarget:self
        action:@selector(home)
        forControlEvents:UIControlEventTouchUpInside];

		window.windowLevel = UIWindowLevelAlert + 1.0;
		[window makeKeyAndVisible];
		[window addSubview:button];
		 [window addSubview:view];
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
