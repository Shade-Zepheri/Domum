#import <UIKit/UIKit.h>

@interface SBUIController
+ (id)sharedInstance;
- (BOOL)clickedMenuButton;
//iOS 10
- (BOOL)handleHomeButtonSinglePressUp;
@end

@interface SBMainSwitcherViewController : UIViewController
+(id)sharedInstance;
-(BOOL)activateSwitcherNoninteractively;
@end

@interface Domum : UIView <UIGestureRecognizerDelegate>
- (instancetype)initWithFrame:(CGRect)frame;
@end
