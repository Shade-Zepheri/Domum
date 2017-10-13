#import "DOMButton.h"
#import "DOMSettings.h"

@implementation DOMButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.imageView.image = [UIImage imageNamed:@"Home" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Domum-Resources.bundle"]];
        self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.imageView];

        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        panGesture.delegate = self;
        [self addGestureRecognizer:panGesture];

        UIPinchGestureRecognizer *scaleGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        scaleGesture.delegate = self;
        [self addGestureRecognizer:scaleGesture];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        tapGesture.numberOfTapsRequired = 1;
        [self addGestureRecognizer:tapGesture];

        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        doubleTapGesture.delegate = self;
        [self addGestureRecognizer:doubleTapGesture];

        [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
        [tapGesture requireGestureRecognizerToFail:panGesture];
        [tapGesture requireGestureRecognizerToFail:scaleGesture];

        _enableDrag = YES;
        self.userInteractionEnabled = YES;
    }

    return self;
}

- (void)handleTap:(UITapGestureRecognizer *)tap {
    if ([%c(SBUIController) respondsToSelector:@selector(clickedMenuButton)]) {
        [[%c(SBUIController) sharedInstance] clickedMenuButton];
    } else {
        [[%c(SBUIController) sharedInstance] handleHomeButtonSinglePressUp];
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)tap {
    if ([%c(SBUIController) respondsToSelector:@selector(handleMenuDoubleTap)]) {
        [[%c(SBUIController) sharedInstance] handleMenuDoubleTap];
    } else {
        [[%c(SBUIController) sharedInstance] handleHomeButtonDoublePressDown];
    }
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
    if (!_enableDrag) {
        return;
    }

    switch (recognizer.state) {
      case UIGestureRecognizerStatePossible:
          break;
      case UIGestureRecognizerStateBegan:
          _initialPoint = recognizer.view.center;
          break;
      case UIGestureRecognizerStateChanged:
          break;
      case UIGestureRecognizerStateEnded:
      case UIGestureRecognizerStateCancelled:
      case UIGestureRecognizerStateFailed:
          [self snapButton];
          [[DOMSettings sharedSettings] saveButtonPosition:recognizer.view.center];
          return;
    }

    UIView *view = recognizer.view;
    CGPoint point = [recognizer translationInView:view.superview];

    CGPoint translatedPoint = CGPointMake(_initialPoint.x + point.x, _initialPoint.y + point.y);
    view.center = translatedPoint;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture {
    switch (gesture.state) {
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateBegan: {
            _enableDrag = NO;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            self.transform = CGAffineTransformScale(self.transform, gesture.scale, gesture.scale);
            gesture.scale = 1.0;
            break;
        }
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateFailed:
            _enableDrag = YES;
            [self snapButton];
            break;
    }
}

- (void)snapButton {
    CGRect viewFrame = self.frame;
    CGRect superViewBounds = self.superview.bounds;

    if (viewFrame.origin.y < superViewBounds.origin.y) {
        viewFrame.origin.y = 0;
    } else if (CGRectGetMaxY(viewFrame) > superViewBounds.size.height) {
        viewFrame.origin.y = superViewBounds.size.height - viewFrame.size.height;
    }

    if (viewFrame.origin.x < superViewBounds.origin.x) {
        viewFrame.origin.x = 0;
    } else if (CGRectGetMaxX(viewFrame) > superViewBounds.size.width) {
        viewFrame.origin.x = superViewBounds.size.width - viewFrame.size.width;
    }

    [UIView animateWithDuration:0.2 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.frame = viewFrame;
    } completion:NULL];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return NO;
    }

    return YES;
}

@end
