#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define kThemeImagePath @"/var/jb/Library/KeyboardTheme/keyboard_bg.png"
#define kThemeTag 20240601

#pragma mark - 主键盘背景处理
%hook UIKBVisualEffectView

- (void)didAddSubview:(UIView *)subview {
    %orig;
    [self applyCustomTheme];
}

- (void)layoutSubviews {
    %orig;
    [self applyCustomTheme];
}

- (void)applyCustomTheme {
    // 移除系统模糊效果
    if ([self respondsToSelector:@selector(setEffect:)]) {
        [self setEffect:nil];
    }
    
    // 避免重复添加
    UIView *existingView = [self viewWithTag:kThemeTag];
    if (existingView) return;
    
    // 创建主题视图
    UIView *themeView = [[UIView alloc] initWithFrame:self.bounds];
    themeView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    themeView.tag = kThemeTag;
    themeView.userInteractionEnabled = NO;
    
    // 加载自定义背景图
    UIImage *bgImage = [UIImage imageWithContentsOfFile:kThemeImagePath];
    if (bgImage) {
        UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
        bgImageView.contentMode = UIViewContentModeScaleAspectFill;
        bgImageView.frame = themeView.bounds;
        bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [themeView addSubview:bgImageView];
    } else {
        themeView.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    }
    
    [self addSubview:themeView];
    [self sendSubviewToBack:themeView];
}

%end

#pragma mark - 候选栏/预测栏处理
%hook UIKeyboardPredictionView

- (void)layoutSubviews {
    %orig;
    
    // 移除候选栏背景模糊
    for (UIView *subview in self.subviews) {
        if ([subview isKindOfClass:%c(UIKBVisualEffectView)]) {
            [(UIKBVisualEffectView *)subview setEffect:nil];
        }
    }
}

%end

#pragma mark - 键盘扩展区域处理
%hook UIInputSetHostView

- (void)didMoveToWindow {
    %orig;
    
    // 处理表情键盘/扩展键盘
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        for (UIView *subview in self.subviews) {
            if ([subview isKindOfClass:%c(UIKBVisualEffectView)]) {
                [(UIKBVisualEffectView *)subview setEffect:nil];
            }
        }
    });
}

%end

#pragma mark - 初始化
%ctor {
    NSLog(@"[KeyboardTheme] 初始化成功 - 版本1.0");
    CFNotificationCenterAddObserver(
        CFNotificationCenterGetDarwinNotifyCenter(),
        NULL,
        (CFNotificationCallback)reloadTheme,
        CFSTR("com.keyboardtheme.reload"),
        NULL,
        CFNotificationSuspensionBehaviorDeliverImmediately
    );
}

static void reloadTheme() {
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"UIKeyboardDidShowNotification" object:nil];
    });
}
