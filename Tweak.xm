#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%hook UIInputViewController  // 钩取输入法控制器

// 修改键盘背景颜色
- (void)viewDidLoad {
    %orig;
    
    // 获取存储的颜色
    NSString *colorString = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"];
    if (colorString) {
        NSArray *components = [colorString componentsSeparatedByString:@","];
        if (components.count == 3) {
            CGFloat red = [components[0] floatValue] / 255.0;
            CGFloat green = [components[1] floatValue] / 255.0;
            CGFloat blue = [components[2] floatValue] / 255.0;
            
            UIColor *color = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
            self.view.backgroundColor = color;
        }
    }
}

// 钩取滑行输入的处理
- (void)handleSwipeInput:(NSString *)character {
    // 获取UITextDocumentProxy用于插入文本
    id<UITextDocumentProxy> proxy = self.inputViewController.inputView;
    if (proxy) {
        [proxy insertText:character];
    } else {
        // 如果没有获取到proxy，使用原始的插入文本方式
        [self.inputViewController insertText:character];
    }
}

// 拦截文本插入行为并处理
- (void)insertText:(NSString *)text {
    %orig(text);  // 调用原始插入文本方法
    // 可在此处添加额外的功能，例如自定义行为
}

%end
