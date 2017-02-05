#import "DomWindow.h"
#import <libactivator/libactivator.h>

@interface DomController : NSObject <LAListener>
@end

static DomController *sharedInstance;

@implementation DomController
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

%ctor {
		sharedInstance = [[DomController alloc] init];
  	[[%c(LAActivator) sharedInstance] registerListener:sharedInstance forName:@"com.shade.domum-hide"];
		[[%c(LAActivator) sharedInstance] registerListener:sharedInstance forName:@"com.shade.domum-show"];
		[[%c(LAActivator) sharedInstance] registerListener:sharedInstance forName:@"com.shade.domum-toggle"];
}
