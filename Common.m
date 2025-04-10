// Common.m
#import "Common.h"

#define USER_DEFAULTS_KEY @"SwipeInputTweakBackgroundColor"

// 获取背景颜色的方法
UIColor *fetchBackgroundColorFromDefaults() {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *colorHex = [defaults stringForKey:USER_DEFAULTS_KEY];
    
    if (!colorHex) {
        return [UIColor blueColor]; // 默认颜色
    }
    
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:colorHex];
    [scanner setScanLocation:1];
    [scanner scanHexInt:&rgbValue];
    
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16) / 255.0
                           green:((rgbValue & 0x00FF00) >> 8) / 255.0
                            blue:(rgbValue & 0x0000FF) / 255.0
                           alpha:1.0];
}

// 自定义背景颜色设置
void setCustomBackgroundColor(NSString *colorHex) {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:colorHex forKey:USER_DEFAULTS_KEY];
    [defaults synchronize];
}
