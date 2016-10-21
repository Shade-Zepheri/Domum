#import <UIKit/UIKit.h>
#import "DomWindow.h"
#import <libactivator/libactivator.h>
#import <libcolorpicker.h>
#define DomPrefsPath @"/User/Library/Preferences/com.shade.domum.plist"

@interface SBUIController
	+(id)sharedInstance;
	-(void)clickedMenuButton;
	-(void)handleMenuDoubleTap;
@end

@interface DomController : NSObject <LAListener>{
		NSUserDefaults *prefs;
}
@property (nonatomic) BOOL inLock;
+ (DomController*)sharedInstance;
-(void)ssHide;
@end
