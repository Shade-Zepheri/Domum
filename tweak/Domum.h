#import <UIKit/UIKit.h>
#import "DomWindow.h"
#import <libactivator/libactivator.h>

@interface DomController : NSObject <LAListener>
+ (DomController*)sharedInstance;
+ (void)initPrefs;
- (void)ssHide;
@end
