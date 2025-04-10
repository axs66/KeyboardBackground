#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "Common.h"

%hook UIInputViewController

- (void)viewDidLoad {
    %orig;
    
    UIColor *bgColor = fetchBackgroundColorFromDefaults();
    self.view.backgroundColor = bgColor;
}

%end


#define USER_DEFAULTS_KEY @"SwipeInputTweakBackgroundColor"

// 插件的主要钩子：UIInputViewController
%hook UIInputViewController

// viewDidLoad：修改键盘背景颜色为用户自定义颜色
- (void)viewDidLoad {
    %orig;
    
    // 从用户设置获取背景颜色（如果没有设置，则默认蓝色）
    UIColor *bgColor = fetchBackgroundColorFromDefaults();
    self.view.backgroundColor = bgColor;
}

// 处理输入事件：滑行输入的检测
- (void)handleInput:(UIEvent *)event {
    if ([event type] == UIEventTypeTouches) {
        NSSet *touches = [event allTouches];  // 使用 allTouches 获取触摸事件
        
        // 检查是否有触摸事件
        if (touches.count > 0) {
            NSLog(@"[SwipeInputTweak] 滑行输入事件 detected");
            // 在此处加入滑行输入的处理逻辑
        }
    } else {
        %orig;  // 调用原始的输入事件处理
    }
}

%end

// 获取用户设置的背景颜色，默认是蓝色
UIColor *fetchBackgroundColorFromDefaults() {
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

// 自定义背景颜色设置方法
%hook UIInputViewController

- (void)setCustomBackgroundColor:(NSString *)colorHex {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:colorHex forKey:USER_DEFAULTS_KEY];
    [defaults synchronize];
    
    // 刷新界面以应用新的背景颜色
    self.view.backgroundColor = fetchBackgroundColorFromDefaults();
}

%end

%hook UIInputViewController

- (void)viewDidLoad {
    %orig;
    
    UIColor *bgColor = fetchBackgroundColorFromDefaults();
    self.view.backgroundColor = bgColor;
}

%end
