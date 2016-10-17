#import "Main.h"
static BOOL inLS = YES;
UIWindow *window;
UIButton *button;
static CGFloat bleft = ([[UIScreen mainScreen] applicationFrame].size.width/2)-24;
static CGFloat btop = ([[UIScreen mainScreen] applicationFrame].size.height)*0.9;

static void loadPrefs(){
	NSDictionary *DSettings = [NSDictionary dictionaryWithContentsOfFile:prefsPath];
  inLS = ([DSettings objectForKey:@"inls"] ? [[DSettings objectForKey:@"inls"] boolValue] : inLS);
	if(!inLS){
		[window _setSecure: NO];
	}else{
		[window _setSecure: YES];
	}
}

static void SShide(){
	if(!window.hidden){
		[window setHidden:YES];
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		    [window setHidden:NO];
		});
	}
}

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg1 {
  %orig();
	window = [[UIWindow alloc] initWithFrame:CGRectMake(bleft,btop,48,48)];
  button = [UIButton buttonWithType:UIButtonTypeCustom];
  [button setImage:[UIImage imageNamed:@"/Library/PreferenceBundles/domum.bundle/Home.png"] forState:UIControlStateNormal];
  button.frame = CGRectMake(0,0,48,48);
  [button addTarget:self
      action:@selector(home)
      forControlEvents:UIControlEventTouchUpInside];

  window.windowLevel = UIWindowLevelAlert + 1.0;
	[window makeKeyAndVisible];
  [window addSubview:button];
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

%hook SBScreenshotManager

- (void)saveScreenshots {
	SShide();
	dispatch_after(0, dispatch_get_main_queue(), ^{
	  %orig();
	});
}

%end

@implementation Domum

- (void)activator:(LAActivator *)activator
	 receiveEvent:(LAEvent *)event
  forListenerName:(NSString *)listenerName{
		if(!window.hidden){
			[window setHidden:YES];
		}else if (window.hidden){
			[window setHidden:NO];
		}
}

@end

static Domum *domumInstance;

%ctor{
	domumInstance = [[Domum alloc] init];
  [[LAActivator sharedInstance] registerListener:domumInstance
                                         forName:@"Domum"];
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.shade.domum/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	loadPrefs();
}
