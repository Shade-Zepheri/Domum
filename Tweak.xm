#import "Domum.h"
static BOOL enabled = YES;
static BOOL inLS = NO;
UIWindow *window;
UIButton *button;
static CGFloat bleft = ([[UIScreen mainScreen] applicationFrame].size.width/2)-24;
static CGFloat btop = ([[UIScreen mainScreen] applicationFrame].size.height)*0.9;

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg1 {
  %orig();
  if (enabled) {
		window = [[UIWindow alloc] initWithFrame:CGRectMake(bleft,btop,48,48)];

		button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:[UIImage imageNamed:@"/Library/PreferenceBundles/domum.bundle/Home.png"] forState:UIControlStateNormal];
		button.frame = CGRectMake(0,0,48,48);
		[button addTarget:self
        action:@selector(home)
        forControlEvents:UIControlEventTouchUpInside];

		window.windowLevel = UIWindowLevelAlert + 1.0;
    if(inLS){
      [window _setSecure: YES];
    }
		[window makeKeyAndVisible];
		[window addSubview:button];
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
