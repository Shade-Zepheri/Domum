#line 1 "Tweak.xm"
#include <mach/mach.h>
#include <mach/mach_time.h>
#include <IOKit/hid/IOHIDEvent.h>

static BOOL enabled = YES;


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

@class SBLockScreenViewController; @class SpringBoard; 
static void (*_logos_orig$_ungrouped$SBLockScreenViewController$finishUIUnlockFromSource$)(_LOGOS_SELF_TYPE_NORMAL SBLockScreenViewController* _LOGOS_SELF_CONST, SEL, int); static void _logos_method$_ungrouped$SBLockScreenViewController$finishUIUnlockFromSource$(_LOGOS_SELF_TYPE_NORMAL SBLockScreenViewController* _LOGOS_SELF_CONST, SEL, int); static void _logos_method$_ungrouped$SBLockScreenViewController$home(_LOGOS_SELF_TYPE_NORMAL SBLockScreenViewController* _LOGOS_SELF_CONST, SEL); 
static __inline__ __attribute__((always_inline)) __attribute__((unused)) Class _logos_static_class_lookup$SpringBoard(void) { static Class _klass; if(!_klass) { _klass = objc_getClass("SpringBoard"); } return _klass; }
#line 7 "Tweak.xm"

static void _logos_method$_ungrouped$SBLockScreenViewController$finishUIUnlockFromSource$(_LOGOS_SELF_TYPE_NORMAL SBLockScreenViewController* _LOGOS_SELF_CONST self, SEL _cmd, int arg1) {
  _logos_orig$_ungrouped$SBLockScreenViewController$finishUIUnlockFromSource$(self, _cmd, arg1);
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

static void _logos_method$_ungrouped$SBLockScreenViewController$home(_LOGOS_SELF_TYPE_NORMAL SBLockScreenViewController* _LOGOS_SELF_CONST self, SEL _cmd) {
	SpringBoard *springboard = (SpringBoard *)[_logos_static_class_lookup$SpringBoard() sharedApplication];
	uint64_t abTime = mach_absolute_time();
	IOHIDEventRef event = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault, *(AbsoluteTime *)&abTime, 0xC, 0x40, YES, 0);
	[springboard _menuButtonDown:event];
	CFRelease(event);
	event = IOHIDEventCreateKeyboardEvent(kCFAllocatorDefault, *(AbsoluteTime *)&abTime, 0xC, 0x40, YES, 0);
	[springboard _menuButtonUp:event];
	CFRelease(event);
}

static __attribute__((constructor)) void _logosLocalInit() {
{Class _logos_class$_ungrouped$SBLockScreenViewController = objc_getClass("SBLockScreenViewController"); if (_logos_class$_ungrouped$SBLockScreenViewController) {MSHookMessageEx(_logos_class$_ungrouped$SBLockScreenViewController, @selector(finishUIUnlockFromSource:), (IMP)&_logos_method$_ungrouped$SBLockScreenViewController$finishUIUnlockFromSource$, (IMP*)&_logos_orig$_ungrouped$SBLockScreenViewController$finishUIUnlockFromSource$);} else {HBLogError(@"logos: nil class %s", "SBLockScreenViewController");}{ char _typeEncoding[1024]; unsigned int i = 0; _typeEncoding[i] = 'v'; i += 1; _typeEncoding[i] = '@'; i += 1; _typeEncoding[i] = ':'; i += 1; _typeEncoding[i] = '\0'; class_addMethod(_logos_class$_ungrouped$SBLockScreenViewController, @selector(home), (IMP)&_logos_method$_ungrouped$SBLockScreenViewController$home, _typeEncoding); }} }
#line 41 "Tweak.xm"
