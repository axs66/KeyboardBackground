#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

// 获取自定义背景颜色的函数（从 UserDefaults 或其他地方）
UIColor* fetchBackgroundColorFromDefaults() {
    NSString *colorString = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"];
    
    if (colorString) {
        // 如果从 UserDefaults 获取到了颜色字符串（例如 "255,0,0"）
        NSArray *colorComponents = [colorString componentsSeparatedByString:@","];
        CGFloat red = [colorComponents[0] floatValue] / 255.0;
        CGFloat green = [colorComponents[1] floatValue] / 255.0;
        CGFloat blue = [colorComponents[2] floatValue] / 255.0;
        return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    }
    // 如果没有保存颜色，则返回默认颜色（例如白色）
    return [UIColor whiteColor];
}

%hook UIInputViewController  // 钩取输入法控制器

// 修改键盘背景颜色
- (void)viewDidLoad {
    %orig;
    
    // 获取自定义背景颜色
    UIColor *bgColor = fetchBackgroundColorFromDefaults();
    
    // 确保背景颜色覆盖整个键盘区域
    self.view.backgroundColor = bgColor;
    
    // 如果有其他子视图需要设置颜色，例如键盘区域的子视图，可以设置为同样的颜色
    for (UIView *subview in self.view.subviews) {
        subview.backgroundColor = bgColor;
    }
}

// 自定义颜色设置功能（如果需要）
- (void)setCustomBackgroundColor:(UIColor *)color {
    // 将颜色存储到 UserDefaults 中
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%.0f,%.0f,%.0f", color.redComponent * 255, color.greenComponent * 255, color.blueComponent * 255] forKey:@"backgroundColor"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

%end
