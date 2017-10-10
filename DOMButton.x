#import "DOMButton.h"

@implementation DOMButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *image = [UIImage imageNamed:@"home" inBundle:[NSBundle bundleWithPath:@"/var/mobile/Library/Domum-Resources.bundle"]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:imageView];

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
          //[self snapButton];
          //[self savePosition];
          break;
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
            //[self snapButton];
            //[self savePosition];
            break;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        return NO;
    }

    return YES;
}

@end
