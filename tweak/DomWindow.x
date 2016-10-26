#import "DomWindow.h"

@implementation DomWindow

- (DomWindow *)init {
	self = [super initWithFrame:[UIScreen mainScreen].bounds];

	if (self) {
    self.windowLevel = UIWindowLevelAlert + 1.0;
		[self _setSecure:YES];
    [self makeKeyAndVisible];
		UIImage *image = [UIImage imageNamed:@"/Library/PreferenceBundles/domum.bundle/Home.png"];
		_imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] applicationFrame].size.width/2)-24,([[UIScreen mainScreen] applicationFrame].size.height)*0.9,48,48)];
		[_imageView setImage:image];
		[self ivSetup];
		[self addSubview:_imageView];
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

- (void)ivSetup{
	_imageView.layer.cornerRadius = _imageView.frame.size.height /2;
	_imageView.layer.masksToBounds = YES;
	_imageView.layer.borderWidth = 0;
	_imageView.userInteractionEnabled = YES;
	UIPanGestureRecognizer *panRecognizer;
	panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
																													action:@selector(wasDragged:)];
	panRecognizer.cancelsTouchesInView = YES;
	[_imageView addGestureRecognizer:panRecognizer];
}

- (void)wasDragged:(UIPanGestureRecognizer *)recognizer {
    UIImageView *imageView = (UIImageView *)recognizer.view;
		CGPoint translation = [recognizer translationInView:imageView];
    CGRect recognizerFrame = recognizer.view.frame;
    recognizerFrame.origin.x += translation.x;
    recognizerFrame.origin.y += translation.y;
    [self lightenImage];
		if (CGRectContainsRect(_imageView.superview.bounds, recognizerFrame)) {
        recognizer.view.frame = recognizerFrame;
	  }
    else {
        if (recognizerFrame.origin.y < _imageView.superview.bounds.origin.y) {
            recognizerFrame.origin.y = 0;
        }
        else if (recognizerFrame.origin.y + recognizerFrame.size.height > _imageView.superview.bounds.size.height) {
            recognizerFrame.origin.y = _imageView.superview.bounds.size.height - recognizerFrame.size.height;
        }
        if (recognizerFrame.origin.x < _imageView.superview.bounds.origin.x) {
            recognizerFrame.origin.x = 0;
        }
        else if (recognizerFrame.origin.x + recognizerFrame.size.width > _imageView.superview.bounds.size.width) {
            recognizerFrame.origin.x = _imageView.superview.bounds.size.width - recognizerFrame.size.width;
        }
    }		[recognizer setTranslation:CGPointZero inView:_imageView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self darkenImage];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
  [self lightenImage];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	float delay = 0.14;
	[self lightenImage];
  if (touch.tapCount < 2){
      [self performSelector:@selector(home) withObject:nil afterDelay:delay];
      [self.nextResponder touchesEnded:touches withEvent:event];
  }else if(touch.tapCount == 2){
      [NSObject cancelPreviousPerformRequestsWithTarget:self];
      [self performSelector:@selector(switcher) withObject:nil afterDelay:delay];
  }
}

- (void)darkenImage{
	[_imageView.layer setBackgroundColor:[UIColor blackColor].CGColor];
	[_imageView.layer setOpacity:0.5];
}

- (void)lightenImage{
	[_imageView.layer setOpacity:1.0];
}

- (void)home{
	[[%c(SBUIController) sharedInstance] clickedMenuButton];
}

- (void)switcher{
	[[%c(SBUIController) sharedInstance] handleMenuDoubleTap];
}

@end
