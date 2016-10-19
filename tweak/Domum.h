#import "DomWindow.h"
#import <libactivator/libactivator.h>

@interface SBUIController
	+(id)sharedInstance;
	-(void)clickedMenuButton;
@end

@interface DomController : NSObject <LAListener>{
		NSUserDefaults *prefs;
}
@property (nonatomic) BOOL inLock;
+ (DomController*)sharedInstance;
-(void)ssHide;
@end
