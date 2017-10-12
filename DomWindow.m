#import "DOMWindow.h"
#import "DOMSettings.h"

@implementation DOMWindow

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.windowLevel = UIWindowLevelAlert + 1.0;
        self._secure = [DOMSettings sharedSettings].showOnLockScreen;;

        [self makeKeyAndVisible];
    }

    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitTestView = [super hitTest:point withEvent:event];
    if (hitTestView == self) {
        hitTestView = nil;
    }

    return hitTestView;
}

@end
