@interface DomSettings : NSObject
@property (nonatomic, assign, readonly) BOOL inLockScreen;
@property (nonatomic, assign, readonly) CGFloat opacity;
@property (nonatomic, assign, readonly) CGFloat size;

+ (instancetype)sharedSettings;

@end
