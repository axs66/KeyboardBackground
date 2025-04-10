#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%hook UIInputViewController  // 钩取输入法控制器

// 修改键盘背景颜色
- (void)viewDidLoad {
    %orig;
    
    // 修改背景颜色为蓝色
    self.view.backgroundColor = [UIColor blueColor];
}

// 钩取滑行输入事件（示例代码）
- (void)handleSwipeInput:(UIEvent *)event {
    // 处理滑行输入的事件逻辑
    NSLog(@"[SwipeInputTweak] 滑行输入事件 detected");
    // 例如：通过 event 获取触摸轨迹并进行处理
}

// 拦截输入事件并处理滑行输入
- (void)handleInput:(UIEvent *)event {
    // 如果是滑行输入事件
    if ([event type] == UIEventTypeTouches) {
        [self handleSwipeInput:event];
    } else {
        // 否则使用原有的处理逻辑
        %orig;
    }
}

%end
