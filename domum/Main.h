#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>
#import <Preferences/PSTableCell.h>
#define DarkGrayColor [UIColor colorWithRed:0.38 green:0.38 blue:0.38 alpha:1.0];
#define GrayColor [UIColor colorWithRed:0.80 green:0.80 blue:0.80 alpha:1.0];

@interface DOMRootListController : PSListController {
	UIStatusBarStyle prevStatusStyle;
}
@end

@interface DOMOptionsController : PSListController {
	UIStatusBarStyle prevStatusStyle;
}
@end

@interface DOMAboutController : PSListController {
	UIStatusBarStyle prevStatusStyle;
}
@end
