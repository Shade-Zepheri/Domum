#import <Cephei/HBPreferences.h>

@interface DOMSettings : NSObject
@property (nonatomic, readonly) BOOL enabled;

@property (nonatomic, readonly) BOOL showOnLockScreen;
@property (nonatomic, readonly) CGFloat opacity;

+ (instancetype)sharedSettings;

- (void)registerPreferenceChangeBlock:(HBPreferencesChangeCallback)callback;

@end
