#import "DomWindow.h"

@implementation DomWindow

+ (instancetype)sharedInstance {
    static DomWindow *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] initWithFrame:UIScreen.mainScreen.bounds];
        [sharedInstance createDomum];
    });
    return sharedInstance;
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

- (void)createDomum {
  _button = [[Domum alloc] initWithFrame:CGRectMake(0, 0, 48, 48)];
  [_button setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height*0.93)];
  [self addSubview:_button];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitTestView = [super hitTest:point withEvent:event];
    if (hitTestView == self) {
        hitTestView = nil;
    }
    return hitTestView;
}

@end
