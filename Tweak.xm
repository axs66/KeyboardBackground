#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%hook UIInputViewController  // 钩取输入法控制器

// 修改键盘背景颜色
- (void)viewDidLoad {
    %orig;
    
    // 修改背景颜色为蓝色
    self.view.backgroundColor = [UIColor blueColor];
}

// 拦截输入事件并处理滑行输入
- (void)handleInput:(UIEvent *)event {
    // 判断是否为滑行输入（触摸事件）
    if ([event type] == UIEventTypeTouches) {
        // 这里处理滑行输入的逻辑
        NSLog(@"[SwipeInputTweak] 滑行输入事件 detected");
        // 根据具体需求实现滑行输入的逻辑
    } else {
        // 其他事件使用原始处理逻辑
        %orig;
    }
}

%end
