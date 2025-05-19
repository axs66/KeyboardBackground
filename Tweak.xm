#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark - 工具方法：获取用户设置的背景颜色
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

#pragma mark - 工具方法：设置自定义颜色（用于调试或设置工具）
void setCustomBackgroundColor(UIColor *color) {
    CIColor *ciColor = [CIColor colorWithCGColor:color.CGColor];
    CGFloat red = ciColor.red * 255.0;
    CGFloat green = ciColor.green * 255.0;
    CGFloat blue = ciColor.blue * 255.0;

    NSString *colorString = [NSString stringWithFormat:@"%.0f,%.0f,%.0f", red, green, blue];
    [[NSUserDefaults standardUserDefaults] setObject:colorString forKey:@"backgroundColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 主键盘模糊背景替换
%hook UIKBVisualEffectView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardTheme] UIKBVisualEffectView layoutSubviews");

    // 关闭系统模糊效果（安全做法，避免 undefined method）
    if ([self respondsToSelector:@selector(setEffect:)]) {
        [self performSelector:@selector(setEffect:) withObject:nil];
    }

    // 添加背景图或颜色，仅添加一次
    if (![self viewWithTag:9527]) {
        CGRect frame = [(UIView *)self frame]; // 安全获取 frame
        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        bgView.tag = 9527;

        // 优先加载背景图
        UIImage *bgImage = [UIImage imageWithContentsOfFile:@"/Library/KeyboardTheme/keyboard_bg.png"];
        if (bgImage) {
            UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
            bgImageView.contentMode = UIViewContentModeScaleAspectFill;
            bgImageView.frame = frame;
            bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [bgView addSubview:bgImageView];
        } else {
            // 无图时使用背景色
            bgView.backgroundColor = fetchBackgroundColorFromDefaults();
        }

        [self addSubview:bgView];
        [self sendSubviewToBack:bgView];
    }
}
%end

#pragma mark - 设置整个输入视图的默认背景颜色
%hook UIInputViewController
- (void)viewDidLoad {
    %orig;
    NSLog(@"[KeyboardTheme] UIInputViewController viewDidLoad");

    UIColor *bgColor = fetchBackgroundColorFromDefaults();
    self.view.backgroundColor = bgColor;

    for (UIView *subview in self.view.subviews) {
        subview.backgroundColor = bgColor;
    }
}
%end

#pragma mark - 常用键盘视图 layoutSubviews 调试 Hook

%hook UIKBKeyView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardTheme] UIKBKeyView layoutSubviews");
}
%end

%hook UIKBKeyBackgroundView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardTheme] UIKBKeyBackgroundView layoutSubviews");
}
%end

%hook UIKBBackdropView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardTheme] UIKBBackdropView layoutSubviews");
}
%end

%hook UIInputView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardTheme] UIInputView layoutSubviews");
}
%end

%hook UIKeyboardDockView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardTheme] UIKeyboardDockView layoutSubviews");
}
%end

#pragma mark - 候选词栏样式调试 Hook

%hook UIKeyboardCandidateViewStyle

- (id)arrowButtonBackgroundColor {
    id color = %orig;
    NSLog(@"[KeyboardTheme] arrowButtonBackgroundColor: %@", color);
    return color;
}

- (id)gridBackgroundColor {
    id color = %orig;
    NSLog(@"[KeyboardTheme] gridBackgroundColor: %@", color);
    return color;
}

- (id)highlightedBackgroundColor {
    id color = %orig;
    NSLog(@"[KeyboardTheme] highlightedBackgroundColor: %@", color);
    return color;
}

- (id)highlightedTextColor {
    id color = %orig;
    NSLog(@"[KeyboardTheme] highlightedTextColor: %@", color);
    return color;
}

- (id)lineColor {
    id color = %orig;
    NSLog(@"[KeyboardTheme] lineColor: %@", color);
    return color;
}

- (id)arrowButtonSeparatorImage {
    id image = %orig;
    NSLog(@"[KeyboardTheme] arrowButtonSeparatorImage: %@", image);
    return image;
}
%end

#pragma mark - 键盘渲染配置调试 Hook

%hook UIKBRenderConfig

- (void)setKeyBackgroundType:(int)type {
    %orig;
    NSLog(@"[KeyboardTheme] setKeyBackgroundType: %d", type);
}

- (void)setKeyBackgroundOpacity:(float)opacity {
    %orig;
    NSLog(@"[KeyboardTheme] setKeyBackgroundOpacity: %f", opacity);
}
%end

#pragma mark - 候选词预测调试 Hook

%hook UIPredictionViewController
- (id)_currentTextSuggestions {
    id suggestions = %orig;
    NSLog(@"[KeyboardTheme] _currentTextSuggestions: %@", suggestions);
    return suggestions;
}
%end
