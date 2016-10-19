#line 1 "tweak/Tweak.xm"
#import "Domum.h"
DomWindow *window;
UIButton *button;
static BOOL inLS = YES;
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

@class SBUIController; @class SpringBoard; @class SBScreenshotManager; 
static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void (*_logos_orig$_ungrouped$SBScreenshotManager$saveScreenshots)(_LOGOS_SELF_TYPE_NORMAL SBScreenshotManager* _LOGOS_SELF_CONST, SEL); static void _logos_method$_ungrouped$SBScreenshotManager$saveScreenshots(_LOGOS_SELF_TYPE_NORMAL SBScreenshotManager* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SBUIController(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SBUIController"); } return _klass; }
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
		[self _setSecure:YES];
		[self makeKeyAndVisible];
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setImage:[UIImage imageNamed:@"/Library/PreferenceBundles/domum.bundle/Home.png"] forState:UIControlStateNormal];
		button.frame = CGRectMake(l,t,48,48);
		[button addTarget:self action:@selector(home)
				forControlEvents:UIControlEventTouchUpInside];
		[button addTarget:self action:@selector(wasDragged:withEvent:)
				forControlEvents:UIControlEventTouchDragInside];
		[self addSubview:button];
	}
	return self;
}

- (void)home{
	[[_logos_static_class_lookup$SBUIController() sharedInstance] clickedMenuButton];
}


- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event {
	UITouch *touch = [[event touchesForView:button] anyObject];

	CGPoint previousLocation = [touch previousLocationInView:button];
	CGPoint location = [touch locationInView:button];
	CGFloat delta_x = location.x - previousLocation.x;
	CGFloat delta_y = location.y - previousLocation.y;

	NSArray *coordinates = [[NSArray alloc] initWithObjects:[CGPointMake(button.center.x + delta_x,
		button.center.y + delta_y)],nil];

	button.center = CGPointMake(button.center.x + delta_x,
		button.center.y + delta_y);
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

static void loadPrefs() {
	NSDictionary *DSettings = [NSDictionary dictionaryWithContentsOfFile:DomPrefsPath];
	inLS = ([DSettings objectForKey:@"inls"] ? [[DSettings objectForKey:@"inls"] boolValue] : inLS);
	[window _setSecure:inLS];
	NSString *darray = [[array valueForKey:@"coordinates"] componentsJoinedByString:@""];
	HBLogDebug(darray);
}

static __attribute__((constructor)) void _logosLocalCtor_25183486(int argc, char **argv, char **envp){
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)loadPrefs, CFSTR("com.shade.domum/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
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
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); if (_logos_class$_ungrouped$SpringBoard) {MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);} else {HBLogError(@"logos: nil class %s", "SpringBoard");}Class _logos_class$_ungrouped$SBScreenshotManager = objc_getClass("SBScreenshotManager"); if (_logos_class$_ungrouped$SBScreenshotManager) {MSHookMessageEx(_logos_class$_ungrouped$SBScreenshotManager, @selector(saveScreenshots), (IMP)&_logos_method$_ungrouped$SBScreenshotManager$saveScreenshots, (IMP*)&_logos_orig$_ungrouped$SBScreenshotManager$saveScreenshots);} else {HBLogError(@"logos: nil class %s", "SBScreenshotManager");}} }
#line 147 "tweak/Tweak.xm"
