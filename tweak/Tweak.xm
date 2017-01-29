#import "Domum.h"
#import "DomWindow.h"
#import "DomSettings.h"
#import "DomController.h"

%hook SpringBoard
	- (void)applicationDidFinishLaunching:(id)arg1 {
		%orig();
		DomWindow *window = [[DomWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
		UIButton *button = [Domum sharedInstance].button;
		[window addSubview:button];
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
	@autoreleasepool {
		HBLogDebug(@"Ran ctor");
		CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &reloadSettings, CFSTR("com.shade.domum/ReloadPrefs"), NULL, 0);
		[DomController sharedInstance];

		dlopen("/usr/lib/libactivator.dylib", RTLD_LAZY);
		Class la = objc_getClass("LAActivator");
		if (la) {
			[[la sharedInstance] registerListener:[DomController sharedInstance] forName:@"com.shade.domum-hide"];
			[[la sharedInstance] registerListener:[DomController sharedInstance] forName:@"com.shade.domum-show"];
			[[la sharedInstance] registerListener:[DomController sharedInstance] forName:@"com.shade.domum-toggle"];
		}
	}
}
