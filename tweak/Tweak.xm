#import "Domum.h"
DomWindow *window;
UIButton *button;
static BOOL inLS = YES;
static CGFloat opa = 1;
static CGFloat l = ([[UIScreen mainScreen] applicationFrame].size.width/2)-24;
static CGFloat t = ([[UIScreen mainScreen] applicationFrame].size.height)*0.9;

%hook SpringBoard
	- (void)applicationDidFinishLaunching:(id)arg1 {
		%orig();
		window = [[DomWindow alloc] init];
	}
%end

%hook SBScreenshotManager
- (void)saveScreenshots {
	[[DomController sharedInstance] ssHide];
		dispatch_after(0, dispatch_get_main_queue(), ^{
		    %orig;
		});
}
%end

@implementation DomWindow

- (DomWindow *)init{
	if( [[[UIDevice currentDevice] systemVersion] floatValue] >= 9.0f ){
		self = [super init];
	}
	else {
		self = [super initWithFrame:[UIScreen mainScreen].bounds];
	}

	if (self) {
		self.windowLevel = UIWindowLevelAlert + 1.0;
		self.backgroundColor = [UIColor clearColor];
		self.clipsToBounds = YES;
		[self _setSecure:YES];
		[self makeKeyAndVisible];
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		UIImage *image = [[UIImage imageNamed:@"/Library/PreferenceBundles/domum.bundle/Home.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
		[button setImage:image forState:UIControlStateNormal];
		button.frame = CGRectMake(l,t,48,48);

		UIPanGestureRecognizer *panRecognizer;
    panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                            action:@selector(wasDragged:)];
		panRecognizer.cancelsTouchesInView = YES;

		UILongPressGestureRecognizer *singleTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(home)];
		singleTap.minimumPressDuration = 0.01;
		[button addGestureRecognizer:singleTap];

		UILongPressGestureRecognizer *doubleTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(switcher)];
		doubleTap.numberOfTapsRequired = 2;
		[button addGestureRecognizer:doubleTap];	
		[singleTap requireGestureRecognizerToFail:doubleTap];

    [button addGestureRecognizer:panRecognizer];
		[self addSubview:button];
	}
	return self;
}

- (void)home{
	[[%c(SBUIController) sharedInstance] clickedMenuButton];
}

- (void)switcher{
	[[%c(SBUIController) sharedInstance] handleMenuDoubleTap];
}

- (void)wasDragged:(UIPanGestureRecognizer *)recognizer {
    UIButton *button = (UIButton *)recognizer.view;
		CGPoint translation = [recognizer translationInView:button];
    CGRect recognizerFrame = recognizer.view.frame;
    recognizerFrame.origin.x += translation.x;
    recognizerFrame.origin.y += translation.y;
		if (CGRectContainsRect(window.bounds, recognizerFrame)) {
		        recognizer.view.frame = recognizerFrame;
		    }
		    else {
		        if (recognizerFrame.origin.y < window.bounds.origin.y) {
		            recognizerFrame.origin.y = 0;
		        }
		        else if (recognizerFrame.origin.y + recognizerFrame.size.height > window.bounds.size.height) {
		            recognizerFrame.origin.y = window.bounds.size.height - recognizerFrame.size.height;
		        }
		        if (recognizerFrame.origin.x < window.bounds.origin.x) {
		            recognizerFrame.origin.x = 0;
		        }
		        else if (recognizerFrame.origin.x + recognizerFrame.size.width > window.bounds.size.width) {
		            recognizerFrame.origin.x = window.bounds.size.width - recognizerFrame.size.width;
		        }
		    }		[recognizer setTranslation:CGPointZero inView:button];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitTestView = [super hitTest:point withEvent:event];
    if (hitTestView == self) {
        hitTestView = nil;
    }
    return hitTestView;
}

@end

@implementation DomController

+ (DomController*)sharedInstance {
	static dispatch_once_t p = 0;
    __strong static DomController* sharedObject = nil;
    dispatch_once(&p, ^{
        sharedObject = [[self alloc] init];
    });
    return sharedObject;
}

- (void)ssHide{
		if(!window.hidden){
			[window setHidden:YES];
			dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.15 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
			    [window setHidden:NO];
			});
		}
}

- (void)activator:(LAActivator *)activator receiveEvent:(LAEvent *)event {
	[event setHandled:YES];

	NSString *eventName = [activator assignedListenerNameForEvent:event];

	if ([eventName isEqualToString:@"com.shade.domum-hide"]) {
		[window setHidden:YES];
	}
	else if ([eventName isEqualToString:@"com.shade.domum-show"]) {
		[window setHidden:NO];
	}
	else if ([eventName isEqualToString:@"com.shade.domum-toggle"]) {
		if(!window.hidden){
			[window setHidden:YES];
		}else{
			[window setHidden:NO];
		}
	}
	else {
		[event setHandled:NO];
	}
}

@end

static void initPrefs() {
	NSDictionary *DSettings = [NSDictionary dictionaryWithContentsOfFile:DomPrefsPath];
	inLS = ([DSettings objectForKey:@"inls"] ? [[DSettings objectForKey:@"inls"] boolValue] : inLS);
	opa = ([DSettings objectForKey:@"opacity"] ? [[DSettings objectForKey:@"opacity"] floatValue] : opa);
	[window _setSecure:inLS];
	window.alpha = opa;
}

static void resetPos() {
	button.frame = CGRectMake(l,t,48,48);
}

%ctor{
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)initPrefs, CFSTR("com.shade.domum/ReloadPrefs"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)resetPos, CFSTR("com.shade.domum/ResetPos"), NULL, CFNotificationSuspensionBehaviorCoalesce);
	initPrefs();
	[DomController sharedInstance];

	dlopen("/usr/lib/libactivator.dylib", RTLD_LAZY);
	Class la = objc_getClass("LAActivator");
	if (la) {
		[[la sharedInstance] registerListener:[DomController sharedInstance] forName:@"com.shade.domum-hide"];
		[[la sharedInstance] registerListener:[DomController sharedInstance] forName:@"com.shade.domum-show"];
		[[la sharedInstance] registerListener:[DomController sharedInstance] forName:@"com.shade.domum-toggle"];
	}
}
