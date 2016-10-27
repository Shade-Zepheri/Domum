#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#import <libcolorpicker.h>
#define DomPrefsPath @"/User/Library/Preferences/com.shade.domum.plist"
#define kBundlePath @"/Library/Application Support/Domum/"
#define kSelfBundlePath @"/Library/PreferenceBundles/Default.bundle"

@interface DOMRootListController : PSListController
@end

@interface DOMOptionsController : PSListController
@end

@interface DOMAboutController : PSListController
@end
