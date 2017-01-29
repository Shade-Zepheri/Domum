#import "Domum.h"

@implementation Domum

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
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/Application Support/Domum"] pathForResource:@"home" ofType:@"png"]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [self addSubview:imageView];

    panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.delegate = self;
    [self addGestureRecognizer:panGesture];

  	scaleGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
  	scaleGesture.delegate = self;
  	[self addGestureRecognizer:scaleGesture];

    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
  	tapGesture.numberOfTapsRequired = 1;
  	[self addGestureRecognizer:tapGesture];

  	doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
  	doubleTapGesture.numberOfTapsRequired = 2;
  	doubleTapGesture.delegate = self;
  	[self addGestureRecognizer:doubleTapGesture];

    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
  	[tapGesture requireGestureRecognizerToFail:scaleGesture];
    [tapGesture requireGestureRecognizerToFail:panGesture];

    self.userInteractionEnabled = YES;
  }

  return self;
}

- (void)handleTap:(UITapGestureRecognizer*)tap {
  [[%c(SBUIController) sharedInstance] handleMenuDoubleTap];
}

- (void)handleDoubleTap:(UITapGestureRecognizer*)tap {
  [[%c(SBUIController) sharedInstance] clickedMenuButton];
}

- (void)handlePan:(UIPanGestureRecognizer*)sender {
	if (sender.state == UIGestureRecognizerStateBegan) {
		initialPoint = sender.view.center;
	} else if (sender.state == UIGestureRecognizerStateEnded) {
		if ([self shouldSnapWindow:self]) {
			[self snapWindow:self toLocation:[self snapLocationForWindow:self] animated:YES];
			return;
		}
		return;
	}

  UIView *view = sender.view;
  CGPoint point = [sender translationInView:view.superview];

  CGPoint translatedPoint = CGPointMake(initialPoint.x + point.x, initialPoint.y + point.y);
  view.center = translatedPoint;
}

- (void)handlePinch:(UIPinchGestureRecognizer *)gesture {
  switch (gesture.state) {
      case UIGestureRecognizerStateBegan: {
        break;
      }
      case UIGestureRecognizerStateChanged: {
        [self setTransform:CGAffineTransformScale(self.transform, gesture.scale, gesture.scale)];
        gesture.scale = 1.0;
        break;
      }
      case UIGestureRecognizerStateEnded: {
        if ([self shouldSnapWindow:self]) {
    			[self snapWindow:self toLocation:[self snapLocationForWindow:self] animated:YES];
    			return;
    		}
        break;
      }
      default:
          break;
  }
}

+ (BOOL)shouldSnapView:(UIView*)view {
	return [self snapLocationForWindow:view] != snapLocationInvalid;
}

+ (snapLocation)snapLocationForView:(UIView*)view {
	CGRect location = view.frame;

	// Convienence values
	CGFloat width = UIScreen.mainScreen._referenceBounds.size.width;
	CGFloat height = UIScreen.mainScreen._referenceBounds.size.height;
	//CGFloat oneThirdsHeight = height / 4;
	CGFloat twoThirdsHeight = (height / 4) * 3;

	CGFloat leftXBuffer = 25;
	CGFloat rightXBuffer = width - 25;
	CGFloat bottomBuffer = height - 25;

	CGPoint topLeft = view.center;
	topLeft.x -= location.size.width / 2;
	topLeft.y -= location.size.height / 2;
	topLeft = CGPointApplyAffineTransform(topLeft, view.transform);

	CGPoint topRight = view.center;
	topRight.x += location.size.width / 2;
	topRight.y -= location.size.height / 2;
	topRight = CGPointApplyAffineTransform(topRight, view.transform);

	CGPoint bottomLeft = view.center;
	bottomLeft.x -= location.size.width / 2;
	bottomLeft.y += location.size.height / 2;
	bottomLeft = CGPointApplyAffineTransform(bottomLeft, view.transform);

	CGPoint bottomRight = view.center;
	bottomRight.x += location.size.width / 2;
	bottomRight.y += location.size.height / 2;
	//bottomRight = CGPointApplyAffineTransform(bottomRight, theView.transform);

	// I am not proud of the below jumps, however i do believe it is the best solution to the problem apart from making weird blocks, which would be a considerable amount of work.

	BOOL didLeft = NO;
	BOOL didRight = NO;

	if (topLeft.x > bottomLeft.x)
		goto try_right;

	if (topLeft.y > bottomLeft.y)
		goto try_bottom;

try_left:
	didLeft = YES;
	// Left
	if (location.origin.x < leftXBuffer && location.origin.y < height / 8)
		return snapLocationLeftTop;
	if (location.origin.x < leftXBuffer && (location.origin.y >= twoThirdsHeight || location.origin.y + location.size.height > height))
		return snapLocationLeftBottom;
	if (location.origin.x < leftXBuffer && location.origin.y >= height / 8 && location.origin.y < twoThirdsHeight)
		return snapLocationLeftMiddle;

try_right:
	didRight = YES;
	// Right
	if (location.origin.x + location.size.width > rightXBuffer && location.origin.y < height / 8)
		return snapLocationRightTop;
	if (location.origin.x + location.size.width > rightXBuffer && (location.origin.y >= twoThirdsHeight || location.origin.y + location.size.height > height))
		return snapLocationRightBottom;
	if (location.origin.x + location.size.width > rightXBuffer && location.origin.y >= height / 8 && location.origin.y < twoThirdsHeight)
		return snapLocationRightMiddle;

	if (!didLeft)
		goto try_left;
	else if (!didRight)
		goto try_right;

try_bottom:

	// Jumps through this off slightly, so we re-check (which may or may not actually be needed, depending on the path it takes)
	if (location.origin.x + location.size.width > rightXBuffer && (location.origin.y >= twoThirdsHeight || location.origin.y + location.size.height > height))
		return snapLocationRightBottom;
	if (location.origin.x < leftXBuffer && (location.origin.y >= twoThirdsHeight || location.origin.y + location.size.height > height))
		return snapLocationLeftBottom;

	if (location.origin.y + location.size.height > bottomBuffer)
		return snapLocationBottom;

//try_top:

	if (location.origin.y < 20 + 25)
		return snapLocationTop;

	// Second time possible verify
	if (!didLeft)
		goto try_left;
	else if (!didRight)
		goto try_right;

	return snapLocationNone;
}

+ (CGPoint)snapCenterForView:(UIView*)view toLocation:(snapLocation)location {
	// Convienence values
	CGFloat width = UIScreen.mainScreen._referenceBounds.size.width;
	CGFloat height = UIScreen.mainScreen._referenceBounds.size.height;

	// Target frame values
	CGRect frame = view.frame;
	CGPoint newCenter = view.center;

	BOOL adjustStatusBar = NO;

	switch (location) {
		case snapLocationLeftTop:
			newCenter = CGPointMake(frame.size.width / 2, (frame.size.height / 2) + 20);
			adjustStatusBar = YES;
			break;
		case snapLocationLeftMiddle:
			newCenter.x = frame.size.width / 2;
			break;
		case snapLocationLeftBottom:
			newCenter = CGPointMake(frame.size.width / 2, height - (frame.size.height / 2));
			break;

		case snapLocationRightTop:
			newCenter = CGPointMake(width - (frame.size.width / 2), (frame.size.height / 2) + 20);
			adjustStatusBar = YES;
			break;
		case snapLocationRightMiddle:
			newCenter.x = width - (frame.size.width / 2);
			break;
		case snapLocationRightBottom:
			newCenter = CGPointMake(width - (frame.size.width / 2), height - (frame.size.height / 2));
			break;

		case snapLocationTop:
			newCenter.y = (frame.size.height / 2) + 20;
			adjustStatusBar = YES;
			break;
		case snapLocationBottom:
			newCenter.y = height - (frame.size.height / 2);
			break;

		case snapLocationBottomCenter:
			newCenter.x = width / 2.0;
			newCenter.y = height - (frame.size.height / 2);
			break;

		case snapLocationInvalid:
		default:
			break;
	}

	if (UIApplication.sharedApplication.statusBarOrientation == UIInterfaceOrientationLandscapeRight && adjustStatusBar) {
		newCenter.y -= 20;
	}
	if (UIApplication.sharedApplication.statusBarOrientation == UIInterfaceOrientationLandscapeRight && (location == snapLocationRightMiddle || location == snapLocationRightBottom || location == snapLocationRightTop)) {
		newCenter.x -= 20;
	} else if (UIApplication.sharedApplication.statusBarOrientation == UIInterfaceOrientationLandscapeLeft && adjustStatusBar) {
		newCenter.y -= 20;
	}
	if (UIApplication.sharedApplication.statusBarOrientation == UIInterfaceOrientationLandscapeLeft && (location == snapLocationLeftMiddle || location == snapLocationLeftBottom || location == snapLocationLeftTop)) {
		newCenter.x += 20;
	}

	return newCenter;
}

+ (void)snapView:(UIView*)view toLocation:(snapLocation)location animated:(BOOL)animated {
	CGPoint newCenter = [self snapCenterForWindow:view toLocation:location];

	if (animated) {
		[UIView animateWithDuration:0.2 animations:^{
			view.center = newCenter;
		} completion:nil];
	} else {
		view.center = newCenter;
	}
}

@end
