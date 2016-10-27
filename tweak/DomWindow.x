#import "DomWindow.h"

static UIImageView *imageView;

@implementation DomWindow

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
			self.windowLevel = UIWindowLevelAlert + 1.0;
			[self _setSecure:YES];
      [self makeKeyAndVisible];
      UIImage *image = [UIImage imageNamed:@"/Library/PreferenceBundles/domum.bundle/Home.png"];
  		imageView = [[UIImageView alloc] initWithFrame:CGRectMake(([[UIScreen mainScreen] applicationFrame].size.width/2)-24,([[UIScreen mainScreen] applicationFrame].size.height)*0.9,48,48)];
  		[imageView setImage:image];
  		[self ivSetup];
      [self addSubview:imageView];
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
	imageView.layer.cornerRadius = imageView.frame.size.height /2;
	imageView.layer.masksToBounds = YES;
	imageView.layer.borderWidth = 0;
	imageView.userInteractionEnabled = YES;
	UIPanGestureRecognizer *panRecognizer;
	panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
																													action:@selector(wasDragged:)];
	panRecognizer.cancelsTouchesInView = YES;
	[imageView addGestureRecognizer:panRecognizer];
}
- (void)wasDragged:(UIPanGestureRecognizer *)recognizer {
    UIImageView *imageView = (UIImageView *)recognizer.view;
		CGPoint translation = [recognizer translationInView:imageView];
    CGRect recognizerFrame = recognizer.view.frame;
    recognizerFrame.origin.x += translation.x;
    recognizerFrame.origin.y += translation.y;
    [self lightenImage];
		if (CGRectContainsRect(imageView.superview.bounds, recognizerFrame)) {
        recognizer.view.frame = recognizerFrame;
	  }
    else {
        if (recognizerFrame.origin.y < imageView.superview.bounds.origin.y) {
            recognizerFrame.origin.y = 0;
        }
        else if (recognizerFrame.origin.y + recognizerFrame.size.height > imageView.superview.bounds.size.height) {
            recognizerFrame.origin.y = imageView.superview.bounds.size.height - recognizerFrame.size.height;
        }
        if (recognizerFrame.origin.x < imageView.superview.bounds.origin.x) {
            recognizerFrame.origin.x = 0;
        }
        else if (recognizerFrame.origin.x + recognizerFrame.size.width > imageView.superview.bounds.size.width) {
            recognizerFrame.origin.x = imageView.superview.bounds.size.width - recognizerFrame.size.width;
        }
    }		[recognizer setTranslation:CGPointZero inView:imageView];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	[self darkenImage];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
  [self lightenImage];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	float delay = 0.145;
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
	[imageView.layer setBackgroundColor:[UIColor blackColor].CGColor];
	[imageView.layer setOpacity:0.5];
}

- (void)lightenImage{
	[imageView.layer setOpacity:1.0];
}

- (void)home{
	[[%c(SBUIController) sharedInstance] clickedMenuButton];
}

- (void)switcher{
	[[%c(SBUIController) sharedInstance] handleMenuDoubleTap];
}

@end

static void resetPos() {
	imageView.frame = CGRectMake(([[UIScreen mainScreen] applicationFrame].size.width/2)-24,([[UIScreen mainScreen] applicationFrame].size.height)*0.9,48,48);
}

%ctor{
  @autoreleasepool{
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)resetPos, CFSTR("com.shade.domum/ResetPos"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  }
}
