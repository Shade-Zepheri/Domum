#import "DomWindow.h"
#import <libactivator/libactivator.h>
#define prefsPath @"/User/Library/Preferences/com.shade.domum.plist"

@interface SBUIController
	+(id)sharedInstance;
	-(void)clickedMenuButton;
@end

@interface DomController : NSObject <LAListener>
+ (DomController*)sharedInstance;
@end
