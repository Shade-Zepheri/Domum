#import "Domum.h"
DomWindow *window;
UIButton *button;
static CGFloat l = ([[UIScreen mainScreen] applicationFrame].size.width/2)-24;
static CGFloat t = ([[UIScreen mainScreen] applicationFrame].size.height)*0.9;

%hook SpringBoard
	- (void)applicationDidFinishLaunching:(id)arg1 {
		%orig();
		window = [[DomWindow alloc] init];
	}
%end

%hook SBScreenshotManager
- (void)saveScreenshots {
	[[DomController sharedInstance] ssHide];
		dispatch_after(0, dispatch_get_main_queue(), ^{
		    %orig;
		});
}
%end

@implementation DomWindow

- (DomWindow *)init{
	if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f ){
		self = [super init];
	}
	else {
		self = [super initWithFrame:[UIScreen mainScreen].bounds];
	}

	if (self) {
		self.windowLevel = UIWindowLevelAlert + 1.0;
		self.backgroundColor = [UIColor clearColor];
		[self makeKeyAndVisible];
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:[UIImage imageNamed:@"/Library/PreferenceBundles/domum.bundle/Home.png"] forState:UIControlStateNormal];
		button.frame = CGRectMake(l,t,48,48);
		[button addTarget:self
				action:@selector(home)
				forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
	}
	return self;
}

- (void)home{
	[[%c(SBUIController) sharedInstance] clickedMenuButton];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitTestView = [super hitTest:point withEvent:event];
    if (hitTestView == self) {
        hitTestView = nil;
    }
    return hitTestView;
}

@end

@implementation DomController

+ (DomController*)sharedInstance {
	static dispatch_once_t p = 0;
    __strong static DomController* sharedObject = nil;
    dispatch_once(&p, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (id)init{
	if (self = [super init]) {
		prefs = [[NSUserDefaults alloc] initWithSuiteName:@"com.shade.domum"];
		[prefs registerDefaults:@{
			@"inlock": @NO,
		}];
	}
	return self;
}

- (void)updatePrefs{
	_inLock = [prefs boolForKey:@"inlock"];
	[window _setSecure:_inLock];
}

- (void)ssHide{
		if(!window.hidden){
			[window setHidden:YES];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			    [window setHidden:NO];
			});
		}
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	[event setHandled:YES];

	NSString *eventName = [activator assignedListenerNameForEvent:event];

	if ([eventName isEqualToString:@"com.shade.domum-hide"]) {
		[window setHidden:YES];
	}
	else if ([eventName isEqualToString:@"com.shade.domum-show"]) {
		[window setHidden:NO];
	}
	else if ([eventName isEqualToString:@"com.shade.domum-toggle"]) {
		if(!window.hidden){
			[window setHidden:YES];
		}else{
			[window setHidden:NO];
		}
	}
	else {
		[event setHandled:NO];
	}
}

@end

void loadPrefs() {
	[[DomController sharedInstance] updatePrefs];
}

%ctor{
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.shade.domum/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	loadPrefs();
	[DomController sharedInstance];

	dlopen("/usr/lib/libactivator.dylib", RTLD_LAZY);
	Class la = objc_getClass("LAActivator");
	if (la) {
		[[la sharedInstance] registerListener:[DomController sharedInstance] forName:@"com.shade.domum-hide"];
		[[la sharedInstance] registerListener:[DomController sharedInstance] forName:@"com.shade.domum-show"];
		[[la sharedInstance] registerListener:[DomController sharedInstance] forName:@"com.shade.domum-toggle"];
	}
}
