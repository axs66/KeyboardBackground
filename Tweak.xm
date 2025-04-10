#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#define USER_DEFAULTS_KEY @"SwipeInputTweakBackgroundColor"

%hook UIInputViewController

// 修改键盘背景颜色为用户自定义颜色
- (void)viewDidLoad {
    %orig;
    
    // 从用户设置获取背景颜色（如果没有设置，则默认蓝色）
    UIColor *bgColor = [self fetchBackgroundColorFromDefaults];
    self.view.backgroundColor = bgColor;
}

// 获取用户设置的背景颜色，默认是蓝色
- (UIColor *)fetchBackgroundColorFromDefaults {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *colorHex = [defaults stringForKey:USER_DEFAULTS_KEY];
    
    // 如果用户没有设置颜色，返回默认的蓝色
    if (!colorHex) {
        return [UIColor blueColor];
    }
    
    // 解析十六进制颜色值
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:colorHex];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                           green:((rgbValue & 0x00FF00) >> 8) / 255.0
                            blue:(rgbValue & 0x0000FF) / 255.0
                           alpha:1.0];
}

// 拦截输入事件并处理滑行输入
- (void)handleInput:(UIEvent *)event {
    if ([event type] == UIEventTypeTouches) {
        // 检查滑行输入的触摸事件
        NSSet *touches = [event touchesForGestureRecognizer:nil];
        
        // 如果检测到滑行输入事件
        if (touches.count > 0) {
            NSLog(@"[SwipeInputTweak] 滑行输入事件 detected");
            // 在此可以加入滑行输入的处理逻辑
        }
    } else {
        // 其他事件使用原始处理逻辑
        %orig;
    }
}

// 提供一个方法来更改背景颜色
- (void)setCustomBackgroundColor:(NSString *)colorHex {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:colorHex forKey:USER_DEFAULTS_KEY];
    [defaults synchronize];
    
    // 刷新界面以应用新的背景颜色
    self.view.backgroundColor = [self fetchBackgroundColorFromDefaults];
}

%end
