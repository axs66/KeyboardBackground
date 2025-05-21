#import <UIKit/UIKit.h>
#import <notify.h>
#import "Settings/ThemeManager.h"

static UIImage *kbt_backgroundImage = nil;
static UIColor *kbt_keyColor = nil;
static UIColor *kbt_candidateBgColor = nil;
static CGFloat kbt_keyAlpha = 0.3;

static void loadTheme() {
    [[ThemeManager sharedManager] reloadConfig];
    NSDictionary *config = [[ThemeManager sharedManager] currentConfig];

    NSString *bgPath = config[@"backgroundImage"];
    if (bgPath && [[NSFileManager defaultManager] fileExistsAtPath:bgPath]) {
        kbt_backgroundImage = [UIImage imageWithContentsOfFile:bgPath];
    } else {
        kbt_backgroundImage = nil;
    }

    NSString *colorHex = config[@"keyColor"];
    if (colorHex) {
        unsigned rgb = 0;
        [[NSScanner scannerWithString:[colorHex stringByReplacingOccurrencesOfString:@"#" withString:@""]] scanHexInt:&rgb];
        kbt_keyColor = [UIColor colorWithRed:((rgb>>16)&0xFF)/255.0 green:((rgb>>8)&0xFF)/255.0 blue:(rgb&0xFF)/255.0 alpha:1.0];
    } else {
        kbt_keyColor = nil;
    }

    NSString *candidateColorHex = config[@"candidateBackgroundColor"];
    if (candidateColorHex) {
        unsigned rgb = 0;
        [[NSScanner scannerWithString:[candidateColorHex stringByReplacingOccurrencesOfString:@"#" withString:@""]] scanHexInt:&rgb];
        kbt_candidateBgColor = [UIColor colorWithRed:((rgb>>16)&0xFF)/255.0 green:((rgb>>8)&0xFF)/255.0 blue:(rgb&0xFF)/255.0 alpha:1.0];
    } else {
        kbt_candidateBgColor = nil;
    }

    NSNumber *alpha = config[@"keyAlpha"];
    if (alpha) {
        kbt_keyAlpha = [alpha floatValue];
    }

    NSLog(@"[KeyboardTheme] Theme reloaded");
}

static void reloadTheme(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    NSLog(@"[KeyboardTheme] Received Darwin notification to reload theme.");
    loadTheme();
}

%ctor {
    CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)reloadTheme, CFSTR("com.axs66.KeyboardTheme/ReloadTheme"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
    loadTheme();
}

%hook UIKBKeyView
- (void)layoutSubviews {
    %orig;
    if (kbt_keyColor) {
        self.backgroundColor = [kbt_keyColor colorWithAlphaComponent:kbt_keyAlpha];
    }
    self.layer.cornerRadius = 6;
    self.layer.masksToBounds = YES;
}
%end

%hook UIKBKeyBackgroundView
- (void)drawRect:(CGRect)rect {
    %orig;
    if (kbt_backgroundImage) {
        [kbt_backgroundImage drawInRect:self.bounds blendMode:kCGBlendModeNormal alpha:kbt_keyAlpha];
    }
}
%end

%hook UIKBBackdropView
- (void)didMoveToWindow {
    %orig;
    if (kbt_backgroundImage) {
        UIImageView *bgView = [[UIImageView alloc] initWithImage:kbt_backgroundImage];
        bgView.frame = self.bounds;
        bgView.contentMode = UIViewContentModeScaleAspectFill;
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self insertSubview:bgView atIndex:0];
    }
}
%end

%hook UIKeyboardCandidateBarCell
- (void)layoutSubviews {
    %orig;
    if (kbt_candidateBgColor) {
        self.backgroundColor = kbt_candidateBgColor;
    }
}
%end

%hook UIKeyboardCandidateView
- (void)didMoveToWindow {
    %orig;
    if (kbt_candidateBgColor) {
        self.backgroundColor = kbt_candidateBgColor;
    }
}
%end

// 添加简单淡入动画示例
%hook UIInputView
- (void)didMoveToWindow {
    %orig;
    self.alpha = 0.0;
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1.0;
    }];
}
%end
