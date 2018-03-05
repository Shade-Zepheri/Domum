#include "DOMRootListController.h"
#import <CepheiPrefs/HBAppearanceSettings.h>

@implementation DOMRootListController

+ (NSString *)hb_specifierPlist {
		return @"Root";
}

- (void)viewDidLoad {
		[super viewDidLoad];

		HBAppearanceSettings *appearance = [[HBAppearanceSettings alloc] init];
		appearance.tintColor = GrayColor;
		appearance.navigationBarTintColor = DarkGrayColor;
		//appearance.navigationBarTitleColor = [UIColor whiteColor];
		//appearance.statusBarTintColor = [UIColor colorWithWhite:1 alpha:0.7f];
		self.hb_appearanceSettings = appearance;

		CGRect frame = CGRectMake(0, 0, CGRectGetWidth(self.table.bounds), 127);
		UIImage *headerImage = [UIImage imageNamed:@"DomumHeader" inBundle:self.bundle];
		UIImageView *headerView = [[UIImageView alloc] initWithFrame:frame];
		headerView.image = headerImage;
		headerView.backgroundColor = [UIColor blackColor];
		headerView.contentMode = UIViewContentModeScaleAspectFit;
		headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;

		self.table.tableHeaderView = headerView;
}

- (void)viewDidLayoutSubviews {
		[super viewDidLayoutSubviews];

		CGRect wrapperFrame = ((UIView *)self.table.subviews[0]).frame;
		CGRect frame = CGRectMake(CGRectGetMinX(wrapperFrame), CGRectGetMinY(self.table.tableHeaderView.frame), CGRectGetWidth(wrapperFrame), CGRectGetHeight(self.table.tableHeaderView.frame));

		self.table.tableHeaderView.frame = frame;
}

@end
