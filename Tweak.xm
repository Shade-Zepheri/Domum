#import "Domum.h"
#import "DomWindow.h"
#import "DomSettings.h"

%hook SpringBoard
- (void)applicationDidFinishLaunching:(id)arg1 {
	%orig;
	DomWindow *window = [[DomWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	Domum *button = [[Domum alloc] initWithFrame:CGRectMake(0,0,51,51);
	[button setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height*0.93)];
	[window addSubview:button];
	reloadSettings();
}
%end

%hook SBScreenshotManager
- (void)saveScreenshots {
	[Domum sharedInstance].button.hidden = YES;
		dispatch_after(0, dispatch_get_main_queue(), ^{
	    %orig;
			[Domum sharedInstance].button.hidden = NO;
	});
}
%end

void reloadSettings(CFNotificationCenterRef center,
                    void *observer,
                    CFStringRef name,
                    const void *object,
                    CFDictionaryRef userInfo)
{
    [DomSettings.sharedSettings reloadSettings];
}

%ctor {
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &reloadSettings, CFSTR("com.shade.domum/ReloadPrefs"), NULL, 0);
}
