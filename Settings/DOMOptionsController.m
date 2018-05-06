#include "DOMOptionsController.h"
#import <CepheiPrefs/HBAppearanceSettings.h>

@implementation DOMOptionsController

+ (NSString *)hb_specifierPlist {
    return @"Options";
}

- (void)viewDidLoad {
    [super viewDidLoad];

    HBAppearanceSettings *appearance = [[HBAppearanceSettings alloc] init];
    appearance.tintColor = GrayColor;
    appearance.navigationBarTintColor = DarkGrayColor;
    appearance.navigationBarTitleColor = [UIColor whiteColor];
    appearance.statusBarTintColor = [UIColor colorWithWhite:1 alpha:0.7f];
    self.hb_appearanceSettings = appearance;
}

@end
