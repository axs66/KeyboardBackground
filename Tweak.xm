#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

%hook UIInputViewController

// 修改键盘背景颜色
- (void)viewDidLoad {
    %orig;

    // 从 UserDefaults 获取背景颜色
    NSString *colorString = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"];
    NSArray *colorComponents = [colorString componentsSeparatedByString:@","];

    if (colorComponents.count == 3) {
        CGFloat red = [colorComponents[0] floatValue] / 255.0;
        CGFloat green = [colorComponents[1] floatValue] / 255.0;
        CGFloat blue = [colorComponents[2] floatValue] / 255.0;

        // 设置键盘背景颜色
        self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    }
}

// 处理九宫格滑行输入
- (void)insertText:(NSString *)text {
    id<UITextDocumentProxy> proxy = self.inputViewController.textDocumentProxy;

    if (proxy) {
        [proxy insertText:text];
    }
}

// 处理自定义输入的文本
- (void)handleInput:(NSString *)character {
    id<UITextDocumentProxy> proxy = self.inputViewController.textDocumentProxy;
    if ([proxy respondsToSelector:@selector(insertText:)]) {
        [proxy insertText:character];
    }
}

%end
