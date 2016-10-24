#import <UIKit/UIKit.h>
#import "DomWindow.h"
#import <libactivator/libactivator.h>
#define DomPrefsPath @"/User/Library/Preferences/com.shade.domum.plist"

@interface SBUIController
	+(id)sharedInstance;
	-(void)clickedMenuButton;
	-(void)handleMenuDoubleTap;
@end

@interface DomController : NSObject <LAListener>
+ (DomController*)sharedInstance;
-(void)ssHide;
@end
