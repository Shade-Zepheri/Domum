#import <UIKit/UIKit.h>

@interface UIWindow (Private)
- (void)_setSecure:(BOOL)secure;
- (void)setHidden:(BOOL)arg1;
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;
@end

@interface DomWindow : UIWindow
@end
