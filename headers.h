#import <SpringBoard/SBUIController.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIImage+Private.h>

@interface SBUIController ()
- (BOOL)clickedMenuButton;
- (BOOL)handleMenuDoubleTap;
//iOS 10
- (BOOL)handleHomeButtonSinglePressUp;
- (BOOL)handleHomeButtonDoublePressDown;
@end

@interface UIWindow (Private)
+ (UIWindow *)keyWindow;
@property (getter=_isSecure, setter=_setSecure:) BOOL _secure;

@end
