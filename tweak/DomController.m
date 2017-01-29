#import "DomController.h"
#import "DomWindow.h"
#import <objc/runtime.h>

@implementation DomController

+ (DomController*)sharedInstance {
	static dispatch_once_t p = 0;
    __strong static DomController* sharedObject = nil;
    dispatch_once(&p, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	[event setHandled:YES];

	NSString *eventName = [activator assignedListenerNameForEvent:event];

	if ([eventName isEqualToString:@"com.shade.domum-hide"]) {
		[DomWindow sharedInstance].hidden = YES;
	} else if ([eventName isEqualToString:@"com.shade.domum-show"]) {
		[DomWindow sharedInstance].hidden = NO;
	} else if ([eventName isEqualToString:@"com.shade.domum-toggle"]) {
		if (![DomWindow sharedInstance].hidden){
			[DomWindow sharedInstance].hidden = YES;
		} else {
			[DomWindow sharedInstance].hidden = NO;
		}
	} else {
		[event setHandled:NO];
	}
}

@end
