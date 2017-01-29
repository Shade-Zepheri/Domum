#import <UIKit/UIKit.h>

@interface SBUIController
	+(id)sharedInstance;
	-(void)clickedMenuButton;
  -(void)handleMenuDoubleTap;
@end

@interface Domum : NSObject
@property (nonatomic, strong) UIButton *button;
+ (instancetype)sharedInstance;
@end
