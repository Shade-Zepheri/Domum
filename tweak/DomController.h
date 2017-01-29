#import <libactivator/libactivator.h>

@interface DomController : NSObject <LAListener>
+ (DomController*)sharedInstance;
@end
