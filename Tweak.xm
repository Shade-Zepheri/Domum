#include <mach/mach.h>
#include <mach/mach_time.h>
#include <IOKit/hid/IOHIDEvent.h>

static BOOL enabled = YES;

%hook SBLockScreenViewController
- (void)finishUIUnlockFromSource:(int)arg1 {
  %orig();
  if (enabled) {
		UIWindow *window = [[UIWindow alloc] initWithFrame:CGRectMake(0,300,[[UIScreen mainScreen] applicationFrame].size.width,20)];
		UIImage *homeImage = [[UIImage imageNamed:@"/Library/PreferenceBundles/domum.bundle/shutdown24.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
		UIView *view = [[UIView alloc] initWithFrame: [window frame]];

		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:homeImage forState:UIControlStateNormal];
		button.frame = CGRectMake(([[UIScreen mainScreen] applicationFrame].size.width/2)-12,0,24,24);
		button.imageView.tintColor = [UIColor whiteColor];
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
