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

- (instancetype)init {
  if (self = [super init]) {
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:[[NSBundle bundleWithPath:@"/Library/Application Support/Domum"] pathForResource:@"home" ofType:@"png"]];
    [_button setBackgroundImage:image forState:UIControlStateNormal];
    _button.frame = CGRectMake(0,0,51,51);
    [_button setCenter:CGPointMake([[UIScreen mainScreen] bounds].size.width/2, [[UIScreen mainScreen] bounds].size.height*0.93)];
    _button.alpha = 1;
    UIPanGestureRecognizer *panRecognizer;
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
    																												action:@selector(wasDragged:)];
    panRecognizer.cancelsTouchesInView = YES;
    [_button addGestureRecognizer:panRecognizer];

    UITapGestureRecognizer *oneTap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(home)];
    UITapGestureRecognizer *twoTap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(switcher)];
    oneTap.numberOfTapsRequired = 1;
    twoTap.numberOfTapsRequired = 2;
    [oneTap requireGestureRecognizerToFail:twoTap];
    [_button addGestureRecognizer:oneTap];
    [_button addGestureRecognizer:twoTap];
  }
  return self;
}

- (void)wasDragged:(UIPanGestureRecognizer *)recognizer {
    UIButton *button = (UIButton *)recognizer.view;
		CGPoint translation = [recognizer translationInView:button];
    CGRect recognizerFrame = recognizer.view.frame;
    recognizerFrame.origin.x += translation.x;
    recognizerFrame.origin.y += translation.y;
		if (CGRectContainsRect(_button.superview.bounds, recognizerFrame)) {
        recognizer.view.frame = recognizerFrame;
	  }
    else {
        if (recognizerFrame.origin.y < _button.superview.bounds.origin.y) {
            recognizerFrame.origin.y = 0;
        }
        else if (recognizerFrame.origin.y + recognizerFrame.size.height > _button.superview.bounds.size.height) {
            recognizerFrame.origin.y = _button.superview.bounds.size.height - recognizerFrame.size.height;
        }
        if (recognizerFrame.origin.x < _button.superview.bounds.origin.x) {
            recognizerFrame.origin.x = 0;
        }
        else if (recognizerFrame.origin.x + recognizerFrame.size.width > _button.superview.bounds.size.width) {
            recognizerFrame.origin.x = _button.superview.bounds.size.width - recognizerFrame.size.width;
        }
    }		[recognizer setTranslation:CGPointZero inView:_button];
}

- (void)home {
  [[%c(SBUIController) sharedInstance] clickedMenuButton];
}

- (void)switcher {
  [[%c(SBUIController) sharedInstance] handleMenuDoubleTap];
}

@end
