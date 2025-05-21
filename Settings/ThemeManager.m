#import "ThemeManager.h"

@implementation ThemeManager

+ (instancetype)sharedManager {
    static ThemeManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
        [shared loadTheme];
    });
    return shared;
}

- (void)loadTheme {
    NSDictionary *prefs = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.yourcompany.keyboardtheme.plist"];
    NSString *themeName = prefs[@"ThemeName"] ?: @"default";
    NSString *path = [NSString stringWithFormat:@"/Library/Application Support/KeyboardTheme/theme_%@.json", themeName];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data) {
        self.currentTheme = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    }
}
@end
