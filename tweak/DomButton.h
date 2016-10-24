#import <UIKit/UIKit.h>

@interface UIButton (Private)
@end

@interface DomButton : UIButton

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
