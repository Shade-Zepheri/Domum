#include "Main.h"

@implementation DOMRootListController

- (NSArray *)specifiers {
	if (!_specifiers) {
		_specifiers = [self loadSpecifiersFromPlistName:@"Domum" target:self];
	}
	return _specifiers;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	CGRect frame = CGRectMake(0, 0, self.table.bounds.size.width, 127);

	UIImage *headerImage = [[UIImage alloc]
		initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/PreferenceBundles/domum.bundle"] pathForResource:@"DomumHeader" ofType:@"png"]];

	UIImageView *headerView = [[UIImageView alloc] initWithFrame:frame];
	[headerView setImage:headerImage];
	headerView.backgroundColor = [UIColor blackColor];
	[headerView setContentMode:UIViewContentModeScaleAspectFit];
	[headerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];

	self.table.tableHeaderView = headerView;
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];

	CGRect wrapperFrame = ((UIView *)self.table.subviews[0]).frame;
	CGRect frame = CGRectMake(wrapperFrame.origin.x, self.table.tableHeaderView.frame.origin.y, wrapperFrame.size.width, self.table.tableHeaderView.frame.size.height);

	self.table.tableHeaderView.frame = frame;
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
