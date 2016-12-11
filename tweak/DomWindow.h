#import <UIKit/UIKit.h>

@interface UIWindow (Private)
- (void)_setSecure:(BOOL)secure;
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;
@end

@interface DomWindow : UIWindow
@end
