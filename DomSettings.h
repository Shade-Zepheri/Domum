@interface DomSettings : NSObject {
	NSDictionary *_settings;
}

+ (instancetype)sharedSettings;
- (void)reloadSettings;
- (BOOL)inLockScreen;
- (CGFloat)opacity;
- (CGFloat)size;

@end
