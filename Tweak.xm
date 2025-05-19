// 引入 UIKit 框架，确保可以访问 UIView、UIImage、UIColor 等属性与方法
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 从偏好设置中读取用户设置的背景颜色（格式为 "255,255,255"）
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

// =================== UIKBVisualEffectView 背景替换 ===================
%hook UIKBVisualEffectView

- (void)layoutSubviews {
    %orig;

    NSLog(@"[KeyboardTheme] UIKBVisualEffectView layoutSubviews hook");

    // 移除模糊背景效果
    if ([self respondsToSelector:@selector(setEffect:)]) {
        [self performSelector:@selector(setEffect:) withObject:nil];
    }

    // 避免重复添加背景视图
    if (![self viewWithTag:9527]) {
        // 新建背景视图，填满整个键盘背景
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        bgView.tag = 9527;

        // 尝试加载图片背景
        UIImage *bgImage = [UIImage imageWithContentsOfFile:@"/Library/KeyboardTheme/keyboard_bg.png"];
        if (bgImage) {
            UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
            bgImageView.contentMode = UIViewContentModeScaleAspectFill;
            bgImageView.frame = self.bounds;
            bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [bgView addSubview:bgImageView];
        } else {
            // 如果没图片，则使用用户设置颜色
            bgView.backgroundColor = fetchBackgroundColorFromDefaults();
        }

        // 添加到键盘背景视图中
        [self addSubview:bgView];
        [self sendSubviewToBack:bgView];
    }
}

%end

// =================== 设置键盘控制器背景色 ===================
%hook UIInputViewController

- (void)viewDidLoad {
    %orig;

    UIColor *bgColor = fetchBackgroundColorFromDefaults();
    self.view.backgroundColor = bgColor;

    // 给子视图统一设置背景色
    for (UIView *subview in self.view.subviews) {
        subview.backgroundColor = bgColor;
    }

    NSLog(@"[KeyboardTheme] UIInputViewController viewDidLoad hook, set background color");
}

%end

// =================== 键盘渲染相关 hook（用于调试观察） ===================
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
