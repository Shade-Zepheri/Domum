#import "Domum.h"

@implementation Domum

- (instancetype)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/Application Support/Domum"] pathForResource:@"home" ofType:@"png"]];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:imageView];

    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    panGesture.cancelsTouchesInView = YES;
    [self addGestureRecognizer:panGesture];

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
  	tapGesture.numberOfTapsRequired = 1;
  	[self addGestureRecognizer:tapGesture];

  	UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
  	doubleTapGesture.numberOfTapsRequired = 2;
  	[self addGestureRecognizer:doubleTapGesture];

    [tapGesture requireGestureRecognizerToFail:doubleTapGesture];
    [tapGesture requireGestureRecognizerToFail:panGesture];

    self.userInteractionEnabled = YES;
  }

  return self;
}

- (void)handleTap:(UITapGestureRecognizer*)tap {
  if ([%c(SBUIController) respondsToSelector:@selector(clickedMenuButton)]) {
    [[%c(SBUIController) sharedInstance] clickedMenuButton];
  } else {
    [[%c(SBUIController) sharedInstance] handleHomeButtonSinglePressUp];
  }
}

- (void)handleDoubleTap:(UITapGestureRecognizer*)tap {
  [[%c(SBMainSwitcherViewController) sharedInstance] activateSwitcherNoninteractively];
}

- (void)handlePan:(UIPanGestureRecognizer *)recognizer {
  UIView *view = (UIView*)recognizer.view;
  CGPoint translation = [recognizer translationInView:view];
  CGRect recognizerFrame = recognizer.view.frame;
  recognizerFrame.origin.x += translation.x;
  recognizerFrame.origin.y += translation.y;
  if (CGRectContainsRect(self.superview.bounds, recognizerFrame)) {
      recognizer.view.frame = recognizerFrame;
  } else {
      if (recognizerFrame.origin.y < self.superview.bounds.origin.y) {
          recognizerFrame.origin.y = 0;
      } else if (recognizerFrame.origin.y + recognizerFrame.size.height > self.superview.bounds.size.height) {
          recognizerFrame.origin.y = self.superview.bounds.size.height - recognizerFrame.size.height;
      }
      if (recognizerFrame.origin.x < self.superview.bounds.origin.x) {
          recognizerFrame.origin.x = 0;
      } else if (recognizerFrame.origin.x + recognizerFrame.size.width > self.superview.bounds.size.width) {
          recognizerFrame.origin.x = self.superview.bounds.size.width - recognizerFrame.size.width;
      }
  }
  [recognizer setTranslation:CGPointZero inView:self];
}

@end
