#import <UIKit/UIKit.h>
#import "DomWindow.h"
#import <libactivator/libactivator.h>
#define DomPrefsPath @"/User/Library/Preferences/com.shade.domum.plist"

@interface DomController : NSObject <LAListener>
+ (DomController*)sharedInstance;
-(void)ssHide;
@end
