#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 补充声明，告诉编译器 UIKBVisualEffectView 是 UIView 子类
@interface UIKBVisualEffectView : UIView
@end

UIColor* fetchBackgroundColorFromDefaults() {
    NSDictionary *prefs = [[NSDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/com.axs.keyboardtheme.plist"];
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

// 自定义设置颜色并保存
void setCustomBackgroundColor(UIColor *color) {
    CIColor *ciColor = [CIColor colorWithCGColor:color.CGColor];
    CGFloat red = ciColor.red * 255.0;
    CGFloat green = ciColor.green * 255.0;
    CGFloat blue = ciColor.blue * 255.0;

    NSString *colorString = [NSString stringWithFormat:@"%.0f,%.0f,%.0f", red, green, blue];
    [[NSUserDefaults standardUserDefaults] setObject:colorString forKey:@"backgroundColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

%hook UIKBVisualEffectView

- (void)layoutSubviews {
    %orig;

    NSLog(@"[+] KeyboardTheme: layoutSubviews hook");

    // 关闭系统模糊效果
    if ([self respondsToSelector:@selector(setEffect:)]) {
        [self performSelector:@selector(setEffect:) withObject:nil];
    }

    // 添加背景图或背景色
    if (![self viewWithTag:9527]) {
        UIView *bgView = [[UIView alloc] initWithFrame:self.bounds];
        bgView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        bgView.tag = 9527;

        // 首先尝试加载背景图
        UIImage *bgImage = [UIImage imageWithContentsOfFile:@"/Library/KeyboardTheme/keyboard_bg.png"];
        if (bgImage) {
            UIImageView *bgImageView = [[UIImageView alloc] initWithImage:bgImage];
            bgImageView.contentMode = UIViewContentModeScaleAspectFill;
            bgImageView.frame = self.bounds;
            bgImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            [bgView addSubview:bgImageView];
        } else {
            // 若无图片则使用用户设置的颜色
            bgView.backgroundColor = fetchBackgroundColorFromDefaults();
        }

        [self addSubview:bgView];
        [self sendSubviewToBack:bgView];
    }
}

%end

%hook UIInputViewController

- (void)viewDidLoad {
    %orig;

    // 设置主控制器视图背景色（以防万一）
    UIColor *bgColor = fetchBackgroundColorFromDefaults();
    self.view.backgroundColor = bgColor;

    for (UIView *subview in self.view.subviews) {
        subview.backgroundColor = bgColor;
    }
}

%end
