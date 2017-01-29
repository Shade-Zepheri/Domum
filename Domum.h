#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, snapLocation)  {
	snapLocationInvalid = 0,

	snapLocationLeftTop,
	snapLocationLeftMiddle,
	snapLocationLeftBottom,

	snapLocationRightTop,
	snapLocationRightMiddle,
	snapLocationRightBottom,

	snapLocationBottom,
	snapLocationTop,
	snapLocationBottomCenter,

	snapLocationBottomLeft = snapLocationLeftBottom,
	snapLocationBottomRight = snapLocationRightBottom,

	snapLocationRight = snapLocationRightMiddle,
	snapLocationLeft = snapLocationLeftMiddle,
	snapLocationNone = snapLocationInvalid,
};

@interface SBUIController
+ (id)sharedInstance;
- (void)clickedMenuButton;
- (void)handleMenuDoubleTap;
@end

@interface Domum : UIView <UIGestureRecognizerDelegate>
+ (instancetype)sharedInstance;
- (instancetype)initWithFrame:(CGRect)frame;

@end
