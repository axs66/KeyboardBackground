#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <substrate.h>

@interface ThemeManager : NSObject
@property (nonatomic, strong) NSDictionary *themeConfig;
+ (instancetype)sharedManager;
- (void)loadTheme;
- (UIColor *)colorForKey:(NSString *)key withDefault:(UIColor *)def;
- (NSString *)imagePathForKey:(NSString *)key;
@end

@implementation ThemeManager
+ (instancetype)sharedManager {
    static ThemeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ThemeManager alloc] init];
        [manager loadTheme];
        [[NSNotificationCenter defaultCenter] addObserver:manager selector:@selector(loadTheme) name:@"com.keyboardtheme.reload" object:nil];
    });
    return manager;
}

- (void)loadTheme {
    NSString *path = @"/Library/Application Support/KeyboardTheme/theme.json";
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data) {
        NSError *error = nil;
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (!error && [json isKindOfClass:[NSDictionary class]]) {
            self.themeConfig = json;
            NSLog(@"[KeyboardTheme] Loaded theme config: %@", self.themeConfig);
        } else {
            NSLog(@"[KeyboardTheme] JSON parse error: %@", error);
        }
    } else {
        NSLog(@"[KeyboardTheme] theme.json not found, using defaults.");
        self.themeConfig = @{};
    }
}

- (UIColor *)colorForKey:(NSString *)key withDefault:(UIColor *)def {
    NSString *hex = self.themeConfig[key];
    if (hex && [hex isKindOfClass:[NSString class]] && hex.length == 7 && [hex hasPrefix:@"#"]) {
        unsigned rgbValue = 0;
        NSScanner *scanner = [NSScanner scannerWithString:[hex substringFromIndex:1]];
        [scanner scanHexInt:&rgbValue];
        return [UIColor colorWithRed:((rgbValue >> 16) & 0xFF)/255.0
                               green:((rgbValue >> 8) & 0xFF)/255.0
                                blue:(rgbValue & 0xFF)/255.0
                               alpha:1.0];
    }
    return def;
}

- (NSString *)imagePathForKey:(NSString *)key {
    NSString *path = self.themeConfig[key];
    if (path && [path isKindOfClass:[NSString class]]) {
        return path;
    }
    return nil;
}
@end


// -------- 调试Hook --------

%hook UIKBKeyView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardHook] UIKBKeyView layoutSubviews");
}
%end

%hook UIKBKeyBackgroundView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardHook] UIKBKeyBackgroundView layoutSubviews");
}
%end

%hook UIKBBackdropView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardHook] UIKBBackdropView layoutSubviews");
}
%end

%hook UIKBVisualEffectView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardHook] UIKBVisualEffectView layoutSubviews");
}
%end

%hook UIInputView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardHook] UIInputView layoutSubviews");
}
%end

%hook UIKeyboardDockView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardHook] UIKeyboardDockView layoutSubviews");
}
%end


// -------- 主要功能Hook --------

%hook UIKBKeyBackgroundView
- (void)drawRect:(CGRect)rect {
    %orig;
    ThemeManager *manager = [ThemeManager sharedManager];
    NSString *bgPath = [manager imagePathForKey:@"backgroundImage"];
    if (bgPath) {
        UIImage *bgImage = [UIImage imageWithContentsOfFile:bgPath];
        if (bgImage) {
            [bgImage drawInRect:self.bounds blendMode:kCGBlendModeNormal alpha:1.0];
            NSLog(@"[KeyboardTheme] Draw custom background image: %@", bgPath);
            return;
        }
    }
}
%end

%hook UIKeyboardCandidateViewStyle
- (id)highlightedBackgroundColor {
    ThemeManager *manager = [ThemeManager sharedManager];
    UIColor *customColor = [manager colorForKey:@"highlightedBackgroundColor" withDefault:(UIColor *)%orig];
    NSLog(@"[KeyboardTheme] highlightedBackgroundColor: %@", customColor);
    return customColor;
}

- (id)arrowButtonBackgroundColor {
    ThemeManager *manager = [ThemeManager sharedManager];
    UIColor *customColor = [manager colorForKey:@"arrowButtonBackgroundColor" withDefault:(UIColor *)%orig];
    return customColor;
}

- (id)gridBackgroundColor {
    ThemeManager *manager = [ThemeManager sharedManager];
    UIColor *customColor = [manager colorForKey:@"gridBackgroundColor" withDefault:(UIColor *)%orig];
    return customColor;
}

- (id)highlightedTextColor {
    ThemeManager *manager = [ThemeManager sharedManager];
    UIColor *customColor = [manager colorForKey:@"highlightedTextColor" withDefault:(UIColor *)%orig];
    return customColor;
}

- (id)lineColor {
    ThemeManager *manager = [ThemeManager sharedManager];
    UIColor *customColor = [manager colorForKey:@"lineColor" withDefault:(UIColor *)%orig];
    return customColor;
}

- (id)arrowButtonSeparatorImage {
    ThemeManager *manager = [ThemeManager sharedManager];
    NSString *imagePath = [manager imagePathForKey:@"arrowButtonSeparatorImage"];
    if (imagePath) {
        UIImage *img = [UIImage imageWithContentsOfFile:imagePath];
        if (img) return img;
    }
    return %orig;
}
%end

%hook UIKBRenderConfig
- (void)setKeyBackgroundOpacity:(float)opacity {
    ThemeManager *manager = [ThemeManager sharedManager];
    NSNumber *opacityNum = manager.themeConfig[@"keyBackgroundOpacity"];
    if (opacityNum) {
        float customOpacity = [opacityNum floatValue];
        NSLog(@"[KeyboardTheme] Override keyBackgroundOpacity: %f", customOpacity);
        %orig(customOpacity);
        return;
    }
    %orig(opacity);
}
%end

%hook UIPredictionViewController
- (id)_currentTextSuggestions {
    id suggestions = %orig;
    NSLog(@"[KeyboardTheme] _currentTextSuggestions: %@", suggestions);
    return suggestions;
}
%end

// ---------- 热重载监听 ----------

%ctor {
    NSLog(@"[KeyboardTheme] Tweak loaded");
    [ThemeManager sharedManager];

    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)^(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
        NSLog(@"[KeyboardTheme] Received reload notification");
        [[ThemeManager sharedManager] loadTheme];
    }, CFSTR("com.keyboardtheme.reload"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
}
