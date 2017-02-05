#import "DomSettings.h"
#import "DomWindow.h"

@implementation DomSettings

+ (instancetype)sharedSettings {
    static DomSettings *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
  if ((self = [super init])) {
    [self reloadSettings];
  }
  return self;
}

- (void)reloadSettings {
  @autoreleasepool {
    if (_settings) {
      _settings = nil;
    }
    CFPreferencesAppSynchronize(CFSTR("com.shade.domum"));
    CFStringRef appID = CFSTR("com.shade.domum");
    CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);

    BOOL failed = NO;

    if (keyList) {
      _settings = (NSDictionary*)CFBridgingRelease(CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost));
      CFRelease(keyList);

      if (!_settings) {
        failed = YES;
      }
    } else {
      failed = YES;
    }
    CFRelease(appID);

    if (failed) {
      _settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.shade.domum.plist"];
    }

    if (!_settings) {
      HBLogError(@"[ReachApp] could not load settings from CFPreferences or NSDictionary");
    }

    [DomWindow sharedInstance].button.alpha = [self opacity];
    [DomWindow sharedInstance].button.frame = CGRectMake(CGRectGetMinX([DomWindow sharedInstance].button.frame), CGRectGetMinY([DomWindow sharedInstance].button.frame), [self size], [self size]);
    [[DomWindow sharedInstance] _setSecure:[self inLockScreen]];
  }
}

- (BOOL)inLockScreen {
  return ([_settings objectForKey:@"inLockScreen"] != nil ? [_settings[@"inLockScreen"] boolValue] : YES);
}

- (CGFloat)opacity {
  return ([_settings objectForKey:@"opacity"] != nil ? [_settings[@"opacity"] floatValue] : 1);
}

- (CGFloat)size {
  return ([_settings objectForKey:@"size"] != nil ? [_settings[@"size"] floatValue] : 51);
}

@end
