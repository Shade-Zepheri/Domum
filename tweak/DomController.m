#import "DomController.h"
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

- (DomWindow*)window {
	static DomWindow* dimWindow = nil;
	if (!dimWindow) {
		dimWindow = [[DomWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	}
	return dimWindow;
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	[event setHandled:YES];

	NSString *eventName = [activator assignedListenerNameForEvent:event];

	if ([eventName isEqualToString:@"com.shade.domum-hide"]) {
		[self window].hidden = YES;
	}
	else if ([eventName isEqualToString:@"com.shade.domum-show"]) {
		[self window].hidden = NO;
	}
	else if ([eventName isEqualToString:@"com.shade.domum-toggle"]) {
		if(![self window].hidden){
			[self window].hidden = YES;
		}else{
			[self window].hidden = NO;
		}
	}
	else {
		[event setHandled:NO];
	}
}



@end
