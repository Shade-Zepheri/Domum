#import "DomWindow.h"
#import "DomSettings.h"

void reloadSettings() {
  [DomSettings.sharedSettings reloadSettings];
}

void resetPosition() {
  [[DomWindow sharedInstance].button setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height*0.93)];

}

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig;

  [DomWindow sharedInstance];
}
%end

%hook SBScreenshotManager
- (void)saveScreenshots {
	[DomWindow sharedInstance].hidden = YES;
		dispatch_after(0, dispatch_get_main_queue(), ^{
	    %orig;
			[DomWindow sharedInstance].hidden = NO;
	});
}
%end

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettings, CFSTR("com.shade.domum/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)resetPosition, CFSTR("com.shade.domum/ResetPosition"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
