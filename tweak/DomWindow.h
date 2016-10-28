#import <UIKit/UIKit.h>
#define kBundlePath @"/Library/Application Support/Domum/"
#define DomPrefsPath @"/User/Library/Preferences/com.shade.domum.plist"

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
