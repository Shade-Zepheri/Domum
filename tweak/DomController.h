#import "DomWindow.h"
#import <libactivator/libactivator.h>

@interface DomController : NSObject <LAListener>
+ (DomController*)sharedInstance;
- (DomWindow*)window;
@end
