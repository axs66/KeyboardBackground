#import <UIKit/UIKit.h>
#import "Settings/ThemeManager.h"

static UIImage *kbt_backgroundImage = nil;

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadTheme, CFSTR("com.axs66.KeyboardTheme/ReloadTheme"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    loadTheme();
}

static void loadTheme() {
    ThemeManager *manager = [ThemeManager sharedManager];
    NSString *imgPath = [manager stringForKey:@"backgroundImage"];
    if (imgPath.length > 0) {
        kbt_backgroundImage = [UIImage imageWithContentsOfFile:imgPath];
    }
}

static void reloadTheme(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    loadTheme();
}

// Hook 渲染背景图层
%hook UIKBKeyBackgroundView
- (void)drawRect:(CGRect)rect {
    %orig;

    if (!kbt_backgroundImage) return;

    [kbt_backgroundImage drawInRect:self.bounds blendMode:kCGBlendModeNormal alpha:0.3];
}
%end

// Hook 候选栏颜色
%hook UIKeyboardCandidateViewStyle
- (UIColor *)backgroundColor {
    UIColor *c = [[ThemeManager sharedManager] colorForKey:@"candidateBackgroundColor"];
    return c ?: %orig;
}
- (UIColor *)highlightedBackgroundColor {
    UIColor *c = [[ThemeManager sharedManager] colorForKey:@"candidateHighlightColor"];
    return c ?: %orig;
}
- (UIColor *)highlightedTextColor {
    UIColor *c = [[ThemeManager sharedManager] colorForKey:@"candidateHighlightTextColor"];
    return c ?: %orig;
}
%end

// 添加调试打印
%hook UIInputView
- (void)layoutSubviews {
    %orig;
    NSLog(@"[KeyboardTheme] UIInputView layoutSubviews triggered.");
}
%end

// 可选：预测词 hook
%hook UIPredictionViewController
- (id)_currentTextSuggestions {
    id suggestions = %orig;
    NSLog(@"[KeyboardTheme] Predictions: %@", suggestions);
    return suggestions;
}
%end
