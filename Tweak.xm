#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark - 工具方法：获取用户设置的背景颜色
// 从偏好设置文件读取用户自定义的RGB背景颜色，返回 UIColor 对象
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
    // 默认白色背景
    return [UIColor whiteColor];
}

#pragma mark - 工具方法：保存自定义颜色（供调试或设置工具使用）
// 将 UIColor 转为字符串并保存到 NSUserDefaults，方便偏好设置读取
void setCustomBackgroundColor(UIColor *color) {
    CIColor *ciColor = [CIColor colorWithCGColor:color.CGColor];
    CGFloat red = ciColor.red * 255.0;
    CGFloat green = ciColor.green * 255.0;
    CGFloat blue = ciColor.blue * 255.0;

    NSString *colorString = [NSString stringWithFormat:@"%.0f,%.0f,%.0f", red, green, blue];
    [[NSUserDefaults standardUserDefaults] setObject:colorString forKey:@"backgroundColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - 主要 Hook：替换键盘模糊背景视图
%hook UIKBVisualEffectView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardTheme] UIKBVisualEffectView layoutSubviews");

    // 关闭系统自带的模糊效果，防止背景遮挡
    if ([self respondsToSelector:@selector(setEffect:)]) {
        [self performSelector:@selector(setEffect:) withObject:nil];
    }

    // 仅添加一次背景视图，避免重复添加导致性能问题
    if (![self viewWithTag:9527]) {
        // 采用安全的 frame 获取方式，防止闪退
        CGRect frame = [(UIView *)self frame];

        // 新建背景容器视图
        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        bgView.tag = 9527;

        // 优先加载用户自定义背景图片
        UIImage *bgImage = [UIImage imageWithContentsOfFile:@"/Library/KeyboardTheme/keyboard_bg.png"];
        if (bgImage) {
            UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
            bgImageView.contentMode = UIViewContentModeScaleAspectFill;
            bgImageView.frame = frame;
            bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [bgView addSubview:bgImageView];
        } else {
            // 图片缺失时使用用户自定义背景色
            bgView.backgroundColor = fetchBackgroundColorFromDefaults();
        }

        [self addSubview:bgView];
        [self sendSubviewToBack:bgView];
    }
}
%end

#pragma mark - 输入视图控制器 Hook：设置整体背景色
%hook UIInputViewController
- (void)viewDidLoad {
    %orig;
    NSLog(@"[KeyboardTheme] UIInputViewController viewDidLoad");

    // 设置键盘整体背景颜色，确保所有子视图统一色调
    UIColor *bgColor = fetchBackgroundColorFromDefaults();
    self.view.backgroundColor = bgColor;

    for (UIView *subview in self.view.subviews) {
        subview.backgroundColor = bgColor;
    }
}
%end

#pragma mark - 其它键盘视图 layoutSubviews Hook 用于调试
// 这些Hook主要用于输出日志，方便调试键盘视图的生命周期
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

#pragma mark - 候选词视图样式 Hook 用于调试和颜色调节
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

#pragma mark - 键盘渲染配置 Hook 用于调试
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

#pragma mark - 候选词预测 Hook
%hook UIPredictionViewController
- (id)_currentTextSuggestions {
    id suggestions = %orig;
    NSLog(@"[KeyboardTheme] _currentTextSuggestions: %@", suggestions);
    return suggestions;
}
%end
