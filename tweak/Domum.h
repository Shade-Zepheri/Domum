#import <UIKit/UIKit.h>
#import "DomController.h"
#import "DomWindow.h"

@interface SBUIController
	+(id)sharedInstance;
	-(void)clickedMenuButton;
  -(void)handleMenuDoubleTap;
@end

@interface Domum : NSObject
@property (nonatomic, strong) UIButton *button;
+ (instancetype)sharedInstance;
@end
