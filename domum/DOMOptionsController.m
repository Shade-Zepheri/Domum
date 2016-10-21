#include "Main.h"

@implementation DOMOptionsController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [[self loadSpecifiersFromPlistName:@"Options" target:self] retain];
	}

	return _specifiers;
}

-(id) readPreferenceValue:(PSSpecifier*)specifier {
	NSDictionary *DSettings = [NSDictionary dictionaryWithContentsOfFile:DomPrefsPath];
	if (!DSettings[specifier.properties[@"key"]]) {
		return specifier.properties[@"default"];
	}
	return DSettings[specifier.properties[@"key"]];
}

-(void) setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier {
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	[defaults addEntriesFromDictionary:[NSDictionary dictionaryWithContentsOfFile:DomPrefsPath]];
	[defaults setObject:value forKey:specifier.properties[@"key"]];
	[defaults writeToFile:DomPrefsPath atomically:YES];
	CFStringRef DPost = (CFStringRef)specifier.properties[@"PostNotification"];
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), DPost, NULL, NULL, YES);
}

- (void)selectColor{
	NSMutableDictionary *prefsDict = [NSMutableDictionary dictionaryWithContentsOfFile:DomPrefsPath];
	if (!prefsDict) prefsDict = [NSMutableDictionary dictionary];
				NSString *fallbackHex = @"#FFFFFF";
	    UIColor *startColor = LCPParseColorString([prefsDict objectForKey:@"color"], fallbackHex);
	    PFColorAlert *alert = [PFColorAlert colorAlertWithStartColor:startColor showAlpha:YES];
	    [alert displayWithCompletion:
	    ^void (UIColor *pickedColor){
				NSString *hexString = [UIColor hexFromColor:pickedColor];
				[prefsDict setObject:hexString forKey:@"color"];
				[prefsDict writeToFile:DomPrefsPath atomically:YES];
	    }];
}

-(void)resetPos{
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shade.domum/ResetPos"), nil, nil, true);
}

@end
