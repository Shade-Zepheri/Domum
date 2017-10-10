#import "DOMButton.h"
#import "DOMWindow.h"

@interface DOMController : NSObject
@property (strong, nonatomic) DOMButton *button;
@property (strong, nonatomic) DOMWindow *window;

+ (instancetype)mainController;

- (void)updateButtonOpacity:(CGFloat)opacity;
- (void)updateWindowVisibility:(BOOL)visible;
- (void)hideButtonForScreenshot;

@end
