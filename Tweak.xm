#import <UIKit/UIKit.h>

// 钩取 UIInputViewController 类
%hook UIInputViewController

// 钩取 viewDidLoad 方法
- (void)viewDidLoad {
    %orig; // 调用原方法，保留原有功能

    // 获取并应用自定义的背景颜色
    UIColor *bgColor = fetchBackgroundColorFromDefaults(); // 获取背景颜色
    self.view.backgroundColor = bgColor; // 设置背景颜色
}

// 你可以根据需要添加其他方法钩取， 例如处理输入事件等
- (void)handleInput:(UIEvent *)event {
    %orig; // 保留原有功能
    // 处理自定义的输入事件
}

// 自定义背景颜色设置方法
- (void)setCustomBackgroundColor:(UIColor *)color {
    %orig; // 保留原有功能
    // 设置新的背景颜色
}

%end
