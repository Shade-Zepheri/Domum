#import "DOMHeaderCell.h"

@implementation DOMHeaderCell
- (id)initWithSpecifier:(PSSpecifier *)specifier{
		self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DomHeaderCell" specifier:specifier];
    if(self){
      CGRect frame = CGRectMake(0, 0, self.table.bounds.size.width, 127);
      NSBundle *bundle = [NSBundle bundleWithPath:@"/Library/PreferenceBundles/domum.bundle"];
      UIImage *header = [UIImage imageWithContentsOfFile:[bundle pathForResource:@"DomumHeader" ofType:@"png"]];
      headerView=[[UIImageView alloc] initWithFrame:frame];
      [headerView setImage:header];
      headerView.backgroundColor = [UIColor blackColor];
      [headerView setContentMode:UIViewContentModeScaleAspectFit];
      [headerView setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
      [self addSubview:headerView];
    }
		return self;
}
@end
