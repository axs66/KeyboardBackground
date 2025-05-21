#import "ThemeManager.h"

@implementation ThemeManager {
    NSDictionary *_currentConfig;
}

+ (instancetype)sharedManager {
    static ThemeManager *shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[self alloc] init];
    });
    return shared;
}

- (NSString *)configPath {
    // 读取用户选定的主题名
    NSString *selectedTheme = [[NSUserDefaults standardUserDefaults] objectForKey:@"KBTSelectedTheme"];
    if (!selectedTheme || selectedTheme.length == 0) {
        selectedTheme = @"theme_default";
    }

    NSString *themeFile = [NSString stringWithFormat:@"%@.json", selectedTheme];
    NSString *fullPath = [@"/var/mobile/Library/Preferences/com.axs66.KeyboardTheme/" stringByAppendingPathComponent:themeFile];

    if (![[NSFileManager defaultManager] fileExistsAtPath:fullPath]) {
        fullPath = [[NSBundle bundleWithPath:@"/Library/MobileSubstrate/DynamicLibraries/KeyboardTheme.bundle"] pathForResource:selectedTheme ofType:@"json"];
    }

    return fullPath;
}

- (void)reloadConfig {
    NSString *path = [self configPath];
    if (path && [[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSError *error = nil;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (!error && [dict isKindOfClass:[NSDictionary class]]) {
            _currentConfig = dict;
        } else {
            NSLog(@"[KeyboardTheme] Failed to parse theme config: %@", error);
            _currentConfig = @{};
        }
    } else {
        NSLog(@"[KeyboardTheme] Theme config file not found.");
        _currentConfig = @{};
    }
}

- (NSDictionary *)currentConfig {
    return _currentConfig ?: @{};
}

@end
