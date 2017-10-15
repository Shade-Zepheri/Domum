#import <SpringBoard/SBUIController.h>
#import <UIKit/UIKit.h>
#import <UIKit/UIImage+Private.h>

#define kScreenWidth CGRectGetMaxX([UIScreen mainScreen].bounds)
#define kScreenHeight CGRectGetMaxY([UIScreen mainScreen].bounds)

@interface SBUIController ()
- (BOOL)clickedMenuButton;
- (BOOL)handleMenuDoubleTap;
//iOS 10
- (BOOL)handleHomeButtonSinglePressUp;
- (BOOL)handleHomeButtonDoublePressDown;
@end

@interface UIWindow (Private)
+ (UIWindow *)keyWindow;
@property (getter=_isSecure, setter=_setSecure:) BOOL _secure;

@end

@interface SBAssistantController : NSObject
+ (instancetype)sharedInstance;
- (BOOL)handleSiriButtonDownEventFromSource:(NSInteger)source activationEvent:(NSInteger)event;
- (void)handleSiriButtonUpEventFromSource:(NSInteger)source;
@end
