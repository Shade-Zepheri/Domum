#include "Main.h"

@implementation DOMRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Domum" target:self] retain];
	}

	return _specifiers;
}

@end
