#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#pragma mark - Hook: UIKBVisualEffectView，用于插入背景视图
%hook UIKBVisualEffectView

- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardTheme] UIKBVisualEffectView layoutSubviews");

    // 取消系统模糊背景效果
    if ([self respondsToSelector:@selector(setEffect:)]) {
        [self performSelector:@selector(setEffect:) withObject:nil];
    }

    // 避免重复添加
    if (![self viewWithTag:9527]) {
        CGRect frame = ((UIView *)self).bounds;

        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        bgView.tag = 9527;

        UIImage *bgImage = [UIImage imageWithContentsOfFile:@"/Library/KeyboardTheme/keyboard_bg.png"];
        if (bgImage) {
            UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
            bgImageView.contentMode = UIViewContentModeScaleAspectFill;
            bgImageView.frame = frame;
            bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [bgView addSubview:bgImageView];
        } else {
            // 图片不存在时使用默认颜色（浅灰）
            bgView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1.0];
        }

        [self addSubview:bgView];
        [self sendSubviewToBack:bgView];
    }
}
%end

#pragma mark - Hook: UIInputViewController 设置主背景色（非必要，可选保留）
%hook UIInputViewController

- (void)viewDidLoad {
    %orig;
    NSLog(@"[KeyboardTheme] UIInputViewController viewDidLoad");

    // 可选：设置整个键盘控制器背景颜色（用于测试/一致性）
    self.view.backgroundColor = [UIColor clearColor];
}
%end

#pragma mark - 其它调试 Hook（保留以供观察键盘生命周期）
%hook UIKBKeyView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardTheme] UIKBKeyView layoutSubviews");
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

%hook UIPredictionViewController
- (id)_currentTextSuggestions {
    id suggestions = %orig;
    NSLog(@"[KeyboardTheme] _currentTextSuggestions: %@", suggestions);
    return suggestions;
}
%end
