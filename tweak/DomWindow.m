#import "DomWindow.h"

@implementation DomWindow

+ (instancetype)sharedInstance {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
			self.windowLevel = UIWindowLevelAlert + 1.0;
			[self _setSecure:YES];
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

- (void)setShowOnLockScreen:(BOOL)show {
  [self _setSecure:show];
}

@end
