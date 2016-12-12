#import "Domum.h"
#import "DomSettings.h"
DomWindow *window;
UIButton *button;

%hook SpringBoard
	- (void)applicationDidFinishLaunching:(id)arg1 {
		%orig();
		window = [[DomController sharedInstance] window];
		button = [[Domum sharedInstance] button];
		[window addSubview:button];
	}
%end

%hook SBScreenshotManager
- (void)saveScreenshots {
	button.hidden = YES;
		dispatch_after(0, dispatch_get_main_queue(), ^{
		    %orig;
				button.hidden = NO;
		});
}
%end

void prefsChanged() {
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.2f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
		button.alpha = [DomSettings sharedSettings].opacity;
		button.frame = CGRectMake(button.frame.origin.x,button.frame.origin.y,[DomSettings sharedSettings].size,[DomSettings sharedSettings].size);
		[window _setSecure:[DomSettings sharedSettings].inLockScreen];
  });
}

void resetPosition() {
	[button setCenter:CGPointMake(button.superview.bounds.size.width/2, button.superview.bounds.size.height*0.93)];
}

%ctor{
	@autoreleasepool{
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
														NULL,
														(CFNotificationCallback)prefsChanged,
														CFSTR("com.shade.domum/ReloadPrefs"),
														NULL,
														CFNotificationSuspensionBehaviorCoalesce);
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(),
														NULL,
														(CFNotificationCallback)resetPosition,
														CFSTR("com.shade.domum/ResetPos"),
														NULL,
														CFNotificationSuspensionBehaviorCoalesce);

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
