#import "Domum.h"
DomWindow *window;
UIImageView *imageView;
static BOOL inLS;
static CGFloat opa;

%hook SpringBoard
	- (void)applicationDidFinishLaunching:(id)arg1 {
		%orig();
		window = [[DomWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		[DomController initPrefs];
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

@implementation DomController

+ (DomController*)sharedInstance {
	static dispatch_once_t p = 0;
    __strong static DomController* sharedObject = nil;
    dispatch_once(&p, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (void)ssHide{
		if(!window.hidden){
			window.hidden = YES;
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			    window.hidden = NO;
			});
		}
}

+ (void)initPrefs{
	CFPreferencesAppSynchronize(CFSTR("com.shade.domum"));
	inLS = !CFPreferencesCopyAppValue(CFSTR("inls"), CFSTR("com.shade.domum")) ? YES : [(__bridge id)CFPreferencesCopyAppValue(CFSTR("inls"), CFSTR("com.shade.domum")) boolValue];
	opa = !CFPreferencesCopyAppValue(CFSTR("opacity"), CFSTR("com.shade.domum")) ? 1 : [(__bridge id)CFPreferencesCopyAppValue(CFSTR("opacity"), CFSTR("com.shade.domum")) floatValue];
	[window _setSecure:inLS];
	window.alpha = opa;
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	[event setHandled:YES];

	NSString *eventName = [activator assignedListenerNameForEvent:event];

	if ([eventName isEqualToString:@"com.shade.domum-hide"]) {
		window.hidden = YES;
	}
	else if ([eventName isEqualToString:@"com.shade.domum-show"]) {
		window.hidden = NO;
	}
	else if ([eventName isEqualToString:@"com.shade.domum-toggle"]) {
		if(!window.hidden){
			window.hidden = YES;
		}else{
			window.hidden = NO;
		}
	}
	else {
		[event setHandled:NO];
	}
}

@end

static void loadPrefs() {
	[DomController initPrefs];
}

%ctor{
	@autoreleasepool{
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.shade.domum/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		loadPrefs();

		[DomController sharedInstance];

		dlopen("/usr/lib/libactivator.dylib", RTLD_LAZY);
		Class la = objc_getClass("LAActivator");
		if (la){
			[[la sharedInstance] registerListener:[DomController sharedInstance] forName:@"com.shade.domum-hide"];
			[[la sharedInstance] registerListener:[DomController sharedInstance] forName:@"com.shade.domum-show"];
			[[la sharedInstance] registerListener:[DomController sharedInstance] forName:@"com.shade.domum-toggle"];
		}
	}
}
