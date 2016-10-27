#import <UIKit/UIKit.h>

@interface SBUIController
	+(id)sharedInstance;
	-(void)clickedMenuButton;
  -(void)handleMenuDoubleTap;
@end

@interface UIWindow (Private)
- (void)_setSecure:(BOOL)secure;
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;
@end

@interface DomWindow : UIWindow
@end
