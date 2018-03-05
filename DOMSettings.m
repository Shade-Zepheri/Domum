#import "DOMSettings.h"

static NSString *const DOMEnabledKey = @"Enabled";

static NSString *const DOMShowOnLockScreenKey = @"ShowOnLockScreen";
static NSString *const DOMOpacityKey = @"Opacity";

@implementation DOMSettings {
    HBPreferences *_preferences;
}

+ (instancetype)sharedSettings {
    static DOMSettings *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _preferences = [HBPreferences preferencesForIdentifier:@"com.shade.domum"];

        [_preferences registerBool:&_enabled default:YES forKey:DOMEnabledKey];

        [_preferences registerBool:&_showOnLockScreen default:YES forKey:DOMShowOnLockScreenKey];
        [_preferences registerFloat:&_opacity default:1 forKey:DOMOpacityKey];
    }

    return self;
}

- (void)registerPreferenceChangeBlock:(HBPreferencesChangeCallback)callback {
    [_preferences registerPreferenceChangeBlock:callback];
}

- (CGPoint)savedButtonPosition {
    CGFloat savedX = [_preferences floatForKey:@"DOMButtonPositionX"];
    CGFloat savedY = [_preferences floatForKey:@"DOMButtonPositionY"];

    return CGPointMake(savedX, savedY);
}

- (void)saveButtonPosition:(CGPoint)position {
    [_preferences setFloat:position.x forKey:@"DOMButtonPositionX"];
    [_preferences setFloat:position.y forKey:@"DOMButtonPositionY"];
}

@end
