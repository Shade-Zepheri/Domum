#include "Main.h"

@implementation DOMAboutController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"About" target:self];
	}

	return _specifiers;
}

- (void)twitter{
	if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetbot:"]]){
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetbot:///user_profile/ShadeZepheri"]];
	}else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitterrific:"]]){
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitterrific:///profile?screen_name=ShadeZepheri"]];
	}else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"tweetings:"]]){
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tweetings:///user?screen_name=ShadeZepheri"]];
	}else if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"twitter:"]]){
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=ShadeZepheri"]];
	}else{
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://mobile.twitter.com/ShadeZepheri"]];
	}
}

- (void)sendEmail{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto:ziroalpha@gmail.com?subject=Domum"]];
}

- (void)github {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/Shade-Zepheri/Domum/tree/master"]];
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
