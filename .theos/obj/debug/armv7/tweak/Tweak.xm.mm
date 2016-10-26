#line 1 "tweak/Tweak.xm"
#import "Domum.h"
DomWindow *window;
static BOOL inLS = YES;
static CGFloat opa = 1;
static CGFloat l = ([[UIScreen mainScreen] applicationFrame].size.width/2)-24;
static CGFloat t = ([[UIScreen mainScreen] applicationFrame].size.height)*0.9;


#include <substrate.h>
#if defined(__clang__)
#if __has_feature(objc_arc)
#define _LOGOS_SELF_TYPE_NORMAL __unsafe_unretained
#define _LOGOS_SELF_TYPE_INIT __attribute__((ns_consumed))
#define _LOGOS_SELF_CONST const
#define _LOGOS_RETURN_RETAINED __attribute__((ns_returns_retained))
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif
#else
#define _LOGOS_SELF_TYPE_NORMAL
#define _LOGOS_SELF_TYPE_INIT
#define _LOGOS_SELF_CONST
#define _LOGOS_RETURN_RETAINED
#endif

@class SpringBoard; @class SBScreenshotManager; 
static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SBScreenshotManager$saveScreenshots)(_LOGOS_SELF_TYPE_NORMAL SBScreenshotManager* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBScreenshotManager$saveScreenshots(_LOGOS_SELF_TYPE_NORMAL SBScreenshotManager* _LOGOS_SELF_CONST, SEL); 

#line 8 "tweak/Tweak.xm"

	static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST self, SEL _cmd, id arg1) {
		_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, arg1);
		window = [[DomWindow alloc] init];
	}



static void _logos_method$_ungrouped$SBScreenshotManager$saveScreenshots(_LOGOS_SELF_TYPE_NORMAL SBScreenshotManager* _LOGOS_SELF_CONST self, SEL _cmd) {
	[[DomController sharedInstance] ssHide];
		dispatch_after(0, dispatch_get_main_queue(), ^{
		    _logos_orig$_ungrouped$SBScreenshotManager$saveScreenshots(self, _cmd);
		});
}


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

static __attribute__((constructor)) void _logosLocalCtor_5c16cf5e(int argc, char **argv, char **envp){
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
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); if (_logos_class$_ungrouped$SpringBoard) {MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);} else {HBLogError(@"logos: nil class %s", "SpringBoard");}Class _logos_class$_ungrouped$SBScreenshotManager = objc_getClass("SBScreenshotManager"); if (_logos_class$_ungrouped$SBScreenshotManager) {MSHookMessageEx(_logos_class$_ungrouped$SBScreenshotManager, @selector(saveScreenshots), (IMP)&_logos_method$_ungrouped$SBScreenshotManager$saveScreenshots, (IMP*)&_logos_orig$_ungrouped$SBScreenshotManager$saveScreenshots);} else {HBLogError(@"logos: nil class %s", "SBScreenshotManager");}} }
#line 97 "tweak/Tweak.xm"
