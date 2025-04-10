#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%hook UIInputViewController  // 钩取输入法控制器

// 修改键盘背景颜色
- (void)viewDidLoad {
    %orig;
    
    // 从NSUserDefaults获取背景颜色
    NSString *colorString = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"];
    
    // 如果用户没有设置背景颜色，则使用默认颜色
    if (colorString == nil) {
        colorString = @"0,0,255";  // 默认背景色为蓝色
    }
    
    // 将颜色字符串转为 UIColor 对象
    NSArray *components = [colorString componentsSeparatedByString:@","];
    CGFloat red = [[components objectAtIndex:0] floatValue] / 255.0;
    CGFloat green = [[components objectAtIndex:1] floatValue] / 255.0;
    CGFloat blue = [[components objectAtIndex:2] floatValue] / 255.0;
    
    UIColor *bgColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    
    // 设置背景颜色
    self.view.backgroundColor = bgColor;
}

// 拦截输入事件并处理滑行输入（去除滑行输入部分，专注于背景修改）
%end
