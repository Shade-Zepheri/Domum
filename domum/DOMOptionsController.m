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

-(void)resetPos{
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shade.domum/ResetPos"), nil, nil, true);
}

-(NSArray *)themeTitles {
    NSMutableArray* files = [[[NSFileManager defaultManager]
                              contentsOfDirectoryAtPath:kBundlePath error:nil] mutableCopy];
    for (int i = 0; i < files.count; i++) {
    	NSString *file = [files objectAtIndex:i];
    	file = [file stringByReplacingOccurrencesOfString:@".bundle" withString:@""];
    	[files replaceObjectAtIndex:i withObject:file];
    }

    return files;
}

-(NSArray *)themeValues {
    NSMutableArray* files = [[[NSFileManager defaultManager]
                              contentsOfDirectoryAtPath:kBundlePath error:nil] mutableCopy];

    return files;
}

@end
