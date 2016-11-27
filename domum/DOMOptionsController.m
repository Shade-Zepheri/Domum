#include "Main.h"

@implementation DOMOptionsController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Options" target:self] retain];
	}

	return _specifiers;
}

-(void)resetPos{
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shade.domum/ResetPos"), nil, nil, true);
}

@end
