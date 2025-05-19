#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 读取用户自定义背景色
UIColor* fetchBackgroundColorFromDefaults() {
    NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.yourname.keyboardtheme.plist"];
    NSString *colorString = prefs[@"backgroundColor"];

    if (colorString) {
        NSArray *colorComponents = [colorString componentsSeparatedByString:@","];
        if (colorComponents.count == 3) {
            CGFloat red = [colorComponents[0] floatValue] / 255.0;
            CGFloat green = [colorComponents[1] floatValue] / 255.0;
            CGFloat blue = [colorComponents[2] floatValue] / 255.0;
            return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
        }
    }
    return [UIColor whiteColor];
}

// 设置用户自定义颜色（如果需要的话）
void setCustomBackgroundColor(UIColor *color) {
    CIColor *ciColor = [CIColor colorWithCGColor:color.CGColor];
    CGFloat red = ciColor.red * 255.0;
    CGFloat green = ciColor.green * 255.0;
    CGFloat blue = ciColor.blue * 255.0;

    NSString *colorString = [NSString stringWithFormat:@"%.0f,%.0f,%.0f", red, green, blue];
    [[NSUserDefaults standardUserDefaults] setObject:colorString forKey:@"backgroundColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// ==================== 主要 UIKBVisualEffectView 背景替换 ====================
%hook UIKBVisualEffectView

- (void)layoutSubviews {
    %orig;

    NSLog(@"[KeyboardTheme] UIKBVisualEffectView layoutSubviews hook");

    // 关闭模糊效果
    if ([self respondsToSelector:@selector(setEffect:)]) {
        [self performSelector:@selector(setEffect:) withObject:nil];
    }

    // 避免重复添加背景视图
    if (![self viewWithTag:9527]) {
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        bgView.tag = 9527;

        // 加载背景图，路径根据你实际路径调整
        UIImage *bgImage = [UIImage imageWithContentsOfFile:@"/Library/KeyboardTheme/keyboard_bg.png"];
        if (bgImage) {
            UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
            bgImageView.contentMode = UIViewContentModeScaleAspectFill;
            bgImageView.frame = self.bounds;
            bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [bgView addSubview:bgImageView];
        } else {
            // 无背景图则使用用户设置颜色
            bgView.backgroundColor = fetchBackgroundColorFromDefaults();
        }

        [self addSubview:bgView];
        [self sendSubviewToBack:bgView];
    }
}

%end

// 主键盘视图控制器背景色
%hook UIInputViewController

- (void)viewDidLoad {
    %orig;

    UIColor *bgColor = fetchBackgroundColorFromDefaults();
    self.view.backgroundColor = bgColor;

    for (UIView *subview in self.view.subviews) {
        subview.backgroundColor = bgColor;
    }

    NSLog(@"[KeyboardTheme] UIInputViewController viewDidLoad hook, set background color");
}

%end

// =================== 你新给的各种Hook ===================

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

%hook UIInputView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardHook] UIInputView layoutSubviews");
}
%end

%hook UIKeyboardCandidateViewStyle
- (id)arrowButtonBackgroundColor {
    id color = %orig;
    NSLog(@"[KeyboardHook] arrowButtonBackgroundColor: %@", color);
    return color;
}

- (id)gridBackgroundColor {
    id color = %orig;
    NSLog(@"[KeyboardHook] gridBackgroundColor: %@", color);
    return color;
}

- (id)highlightedBackgroundColor {
    id color = %orig;
    NSLog(@"[KeyboardHook] highlightedBackgroundColor: %@", color);
    return color;
}

- (id)highlightedTextColor {
    id color = %orig;
    NSLog(@"[KeyboardHook] highlightedTextColor: %@", color);
    return color;
}

- (id)lineColor {
    id color = %orig;
    NSLog(@"[KeyboardHook] lineColor: %@", color);
    return color;
}

- (id)arrowButtonSeparatorImage {
    id image = %orig;
    NSLog(@"[KeyboardHook] arrowButtonSeparatorImage: %@", image);
    return image;
}
%end

%hook UIKBRenderConfig
- (void)setKeyBackgroundType:(int)type {
    %orig;
    NSLog(@"[KeyboardHook] setKeyBackgroundType: %d", type);
}

- (void)setKeyBackgroundOpacity:(float)opacity {
    %orig;
    NSLog(@"[KeyboardHook] setKeyBackgroundOpacity: %f", opacity);
}
%end

%hook UIPredictionViewController
- (id)_currentTextSuggestions {
    id suggestions = %orig;
    NSLog(@"[KeyboardHook] _currentTextSuggestions: %@", suggestions);
    return suggestions;
}
%end

%hook UIKeyboardDockView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardHook] UIKeyboardDockView layoutSubviews");
}
%end
