#include "Main.h"

@implementation DOMOptionsController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Options" target:self];
	}

	return _specifiers;
}

-(void)resetPos{
	CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.shade.domum/ResetPos"), nil, nil, true);
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationController.navigationBar.tintColor = GrayColor;
	self.navigationController.navigationController.navigationBar.barTintColor = DarkGrayColor;
	self.navigationController.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};

	[UISlider appearanceWhenContainedInInstancesOfClasses:@[[self class]]].tintColor = GrayColor;
	[UISwitch appearanceWhenContainedInInstancesOfClasses:@[[self class]]].onTintColor = GrayColor;
	[UISegmentedControl appearanceWhenContainedInInstancesOfClasses:@[[self class]]].tintColor = GrayColor;

	prevStatusStyle = [[UIApplication sharedApplication] statusBarStyle];
	[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	self.navigationController.navigationController.navigationBar.tintColor = nil;
	self.navigationController.navigationController.navigationBar.barTintColor = nil;
	self.navigationController.navigationController.navigationBar.titleTextAttributes = nil;

	[[UIApplication sharedApplication] setStatusBarStyle:prevStatusStyle];
	prevStatusStyle = [[UIApplication sharedApplication] statusBarStyle];
}

@end
