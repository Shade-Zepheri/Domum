#import <UIKit/UIKit.h>
#import "Domum.h"

@interface UIWindow (Private)
- (void)_setSecure:(BOOL)secure;
@end

@interface DomWindow : UIWindow
@property (nonatomic, strong) Domum *button;
+ (instancetype)sharedInstance;
- (instancetype)initWithFrame:(CGRect)frame;
@end
