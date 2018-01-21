#import "DOMController.h"
#import "DOMSettings.h"

static inline void initializeTweak(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [DOMController mainController];
}

%group iOS9
%hook SBScreenShotter
- (void)saveScreenshot:(BOOL)save {
    [[DOMController mainController] hideButtonForScreenshot];

    dispatch_after(0, dispatch_get_main_queue(), ^{
        %orig;
    });
}
%end
%end


%group iOS93
%hook SBScreenshotManager
- (void)saveScreenshotsWithCompletion:(id)completion {
    [[DOMController mainController] hideButtonForScreenshot];

    dispatch_after(0, dispatch_get_main_queue(), ^{
        %orig;
    });
}
%end
%end

%ctor {
    if (%c(SBScreenshotManager)) {
        %init(iOS93);
    } else {
        %init(iOS9);
    }

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, &initializeTweak, CFSTR("SBSpringBoardDidLaunchNotification"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    [DOMSettings sharedSettings];
}
