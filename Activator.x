#import "DOMController.h"
#import <libactivator/libactivator.h>

@interface DOMActivatorListener : NSObject <LAListener>

@end

static DOMActivatorListener *sharedInstance;

@implementation DOMActivatorListener
- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
		event.handled = YES;

		NSString *eventName = [activator assignedListenerNameForEvent:event];

		if ([eventName isEqualToString:@"com.shade.domum-hide"]) {
				[DOMController mainController].button.hidden = YES;
		} else if ([eventName isEqualToString:@"com.shade.domum-show"]) {
				[DOMController mainController].button.hidden = NO;
		} else if ([eventName isEqualToString:@"com.shade.domum-toggle"]) {
				if (![DOMController mainController].button.hidden){
						[DOMController mainController].button.hidden= YES;
				} else {
						[DOMController mainController].button.hidden= NO;
				}
		} else {
				event.handled = NO;
		}
}

@end

%ctor {
		sharedInstance = [[DOMActivatorListener alloc] init];
		[[%c(LAActivator) sharedInstance] registerListener:sharedInstance forName:@"com.shade.domum-hide"];
		[[%c(LAActivator) sharedInstance] registerListener:sharedInstance forName:@"com.shade.domum-show"];
		[[%c(LAActivator) sharedInstance] registerListener:sharedInstance forName:@"com.shade.domum-toggle"];
}
