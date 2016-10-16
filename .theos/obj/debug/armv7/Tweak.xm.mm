#line 1 "Tweak.xm"
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

@class SpringBoard; 
static void (*_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$)(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL, id); static void _logos_method$_ungrouped$SpringBoard$home(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SpringBoard(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SpringBoard"); } return _klass; }
#line 18 "Tweak.xm"

static void _logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST self, SEL _cmd, id arg1) {
  _logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$(self, _cmd, arg1);
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
    window.setSecure = YES;
		[window makeKeyAndVisible];
		[window addSubview:button];
		 [window addSubview:view];
  }
}

static void _logos_method$_ungrouped$SpringBoard$home(_LOGOS_SELF_TYPE_NORMAL SpringBoard* _LOGOS_SELF_CONST self, SEL _cmd) {
	SpringBoard *springboard = (SpringBoard *)[_logos_static_class_lookup$SpringBoard() sharedApplication];
	uint64_t abTime = mach_absolute_time();
	IOHIDEventRef event = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault, *(AbsoluteTime *)&abTime, 0xC, 0x40, YES, 0);
	[springboard _menuButtonDown:event];
	CFRelease(event);
	event = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault, *(AbsoluteTime *)&abTime, 0xC, 0x40, YES, 0);
	[springboard _menuButtonUp:event];
	CFRelease(event);
}


static __attribute__((constructor)) void _logosLocalCtor_da6b7450(int argc, char **argv, char **envp) {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
                                    NULL,
                                    (CFNotificationCallback)loadPrefs,
                                    CFSTR(prefsChanged),
                                    NULL,
                                    CFNotificationSuspensionBehaviorCoalesce);
	loadPrefs();
}
static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SpringBoard = objc_getClass("SpringBoard"); if (_logos_class$_ungrouped$SpringBoard) {MSHookMessageEx(_logos_class$_ungrouped$SpringBoard, @selector(applicationDidFinishLaunching:), (IMP)&_logos_method$_ungrouped$SpringBoard$applicationDidFinishLaunching$, (IMP*)&_logos_orig$_ungrouped$SpringBoard$applicationDidFinishLaunching$);} else {HBLogError(@"logos: nil class %s", "SpringBoard");}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SpringBoard, @selector(home), (IMP)&_logos_method$_ungrouped$SpringBoard$home, _typeEncoding); }} }
#line 61 "Tweak.xm"
