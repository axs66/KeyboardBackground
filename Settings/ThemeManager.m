#import "ThemeManager.h"

@implementation ThemeManager {
    NSDictionary *_themeDict;
}

+ (instancetype)sharedManager {
    static ThemeManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
        [sharedInstance reloadConfig];
    });
    return sharedInstance;
}

- (NSString *)configPath {
    NSString *selectedTheme = [[NSUserDefaults standardUserDefaults] stringForKey:@"kbt_selectedTheme"];
    if (!selectedTheme || selectedTheme.length == 0) {
        selectedTheme = @"theme_default.json";
    }
    NSString *path = [NSString stringWithFormat:@"/Library/Application Support/KeyboardTheme/%@", selectedTheme];
    return path;
}

- (void)reloadConfig {
    NSString *path = [self configPath];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data) {
        NSError *error;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
        if (!error && [json isKindOfClass:[NSDictionary class]]) {
            _themeDict = json;
            NSLog(@"[ThemeManager] Loaded theme: %@", path);
        } else {
            NSLog(@"[ThemeManager] Failed to parse theme JSON: %@", error);
        }
    } else {
        NSLog(@"[ThemeManager] Theme file not found: %@", path);
    }
}

- (NSString *)stringForKey:(NSString *)key {
    id val = _themeDict[key];
    return [val isKindOfClass:[NSString class]] ? val : nil;
}

- (UIColor *)colorForKey:(NSString *)key {
    NSString *hex = [self stringForKey:key];
    if (!hex || hex.length == 0) return nil;

    unsigned int r, g, b;
    if (hex.length == 6 &&
        [[NSScanner scannerWithString:[hex substringWithRange:NSMakeRange(0, 2)]] scanHexInt:&r] &&
        [[NSScanner scannerWithString:[hex substringWithRange:NSMakeRange(2, 2)]] scanHexInt:&g] &&
        [[NSScanner scannerWithString:[hex substringWithRange:NSMakeRange(4, 2)]] scanHexInt:&b]) {
        return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1.0];
    }
    return nil;
}

@end
