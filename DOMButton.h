@interface DOMButton : UIView <UIGestureRecognizerDelegate> {
    BOOL _enableDrag;
    CGPoint _initialPoint;
}
@property (strong, nonatomic) UIImageView *imageView;

- (instancetype)initWithFrame:(CGRect)frame;

@end
