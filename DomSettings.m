#import "DOMSettings.h"
#import "DOMController.h"

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

        [_preferences registerPreferenceChangeBlock:^{
            [[DOMController mainController] updateButtonOpacity:_opacity];
            [[DOMController mainController] updateWindowVisibility:_showOnLockScreen];
        }];
    }

    return self;
}

@end
