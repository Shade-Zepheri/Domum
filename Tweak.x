#import "DOMController.h"
#import "DOMSettings.h"

#pragma mark - Setup

void (^initializeTweak)(NSNotification *) = ^(NSNotification *nsNotification) {
    // Create button
    [DOMController mainController];
};

#pragma mark - Hooks

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

#pragma mark - Constructor

%ctor {
    // Init hooks
    if (%c(SBScreenshotManager)) {
        %init(iOS93);
    } else {
        %init(iOS9);
    }

    // Create singleton
    [DOMSettings sharedSettings];

    // Create view when SpringBoard loads
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:initializeTweak];
}
