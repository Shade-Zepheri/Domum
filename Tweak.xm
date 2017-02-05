#import "Domum.h"
#import "DomWindow.h"
#import "DomSettings.h"

DomWindow *window;
Domum *button;

void reloadSettings() {
    [DomSettings.sharedSettings reloadSettings];
}

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig;

	window = [[DomWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];

  button = [[Domum alloc] initWithFrame:CGRectMake(0,0,51,51)];
  [button setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height*0.93)];
  [window addSubview:button];
}
%end

%hook SBScreenshotManager
- (void)saveScreenshots {
	[Domum sharedInstance].hidden = YES;
		dispatch_after(0, dispatch_get_main_queue(), ^{
	    %orig;
			[Domum sharedInstance].hidden = NO;
	});
}
%end

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadSettings, CFSTR("com.shade.domum/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
}
