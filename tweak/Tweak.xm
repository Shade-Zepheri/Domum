#import "Domum.h"
DomWindow *window;
static BOOL inLS = YES;
static CGFloat opa = 1;
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

static void initPrefs() {
	NSDictionary *DSettings = [NSDictionary dictionaryWithContentsOfFile:DomPrefsPath];
	inLS = ([DSettings objectForKey:@"inls"] ? [[DSettings objectForKey:@"inls"] boolValue] : inLS);
	opa = ([DSettings objectForKey:@"opacity"] ? [[DSettings objectForKey:@"opacity"] floatValue] : opa);
	[window _setSecure:inLS];
	window.alpha = opa;
}

static void resetPos() {
	DomWindow.imageView.frame = CGRectMake(100,100,48,48);
}

%ctor{
	@autoreleasepool{
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)initPrefs, CFSTR("com.shade.domum/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)resetPos, CFSTR("com.shade.domum/ResetPos"), NULL, CFNotificationSuspensionBehaviorCoalesce);
		initPrefs();
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
