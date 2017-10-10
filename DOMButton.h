#import "headers.h"

@interface DOMButton : UIView <UIGestureRecognizerDelegate> {
    BOOL _enableDrag;
    CGPoint _initialPoint;
}

- (instancetype)initWithFrame:(CGRect)frame;

@end
