#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface NineGridKeyboard : UIInputViewController
@property (nonatomic, strong) UIView *nineGridView; // 九宫格视图
@property (nonatomic, strong) UIColor *backgroundColor; // 键盘背景颜色
@end

@implementation NineGridKeyboard

// 键盘视图加载时设置背景颜色和九宫格
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置自定义背景颜色
    [self setupBackgroundColor];
    
    // 设置九宫格布局
    [self setupNineGridLayout];
}

// 设置背景颜色
- (void)setupBackgroundColor {
    NSString *colorString = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"];
    if (colorString) {
        NSArray *components = [colorString componentsSeparatedByString:@","];
        CGFloat red = [components[0] floatValue] / 255.0;
        CGFloat green = [components[1] floatValue] / 255.0;
        CGFloat blue = [components[2] floatValue] / 255.0;
        self.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    } else {
        self.backgroundColor = [UIColor lightGrayColor]; // 默认背景色
    }
    
    self.view.backgroundColor = self.backgroundColor; // 设置背景颜色
}

// 设置九宫格布局
- (void)setupNineGridLayout {
    self.nineGridView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.nineGridView];
    
    // 创建9个按钮作为九宫格的格子
    NSArray *titles = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    CGFloat buttonWidth = self.view.bounds.size.width / 3;
    CGFloat buttonHeight = self.view.bounds.size.height / 3;
    
    for (int i = 0; i < 9; i++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((i % 3) * buttonWidth, (i / 3) * buttonHeight, buttonWidth, buttonHeight);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        button.tag = i; // 设置每个按钮的唯一标识
        [button addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.nineGridView addSubview:button];
    }
}

// 按钮点击事件
- (void)buttonTapped:(UIButton *)sender {
    NSString *character = [NSString stringWithFormat:@"%@", sender.titleLabel.text];
    [self insertText:character]; // 将点击的字符插入到输入框中
}

// 处理滑行输入的手势
- (void)handleSwipeInputWithEvent:(UIEvent *)event {
    // 在这里，你可以处理滑行输入的逻辑，例如根据滑动路径返回对应的字符。
    // 这里只是一个简单的模拟，当用户滑动时输出 'Swipe Detected'
    NSLog(@"[SwipeInputTweak] 滑行输入事件 detected");
}

@end

// 键盘颜色设置
%hook UIInputViewController

- (void)viewDidLoad {
    %orig;
    
    // 获取用户设置的背景颜色
    NSString *colorString = [[NSUserDefaults standardUserDefaults] objectForKey:@"backgroundColor"];
    if (colorString) {
        NSArray *components = [colorString componentsSeparatedByString:@","];
        CGFloat red = [components[0] floatValue] / 255.0;
        CGFloat green = [components[1] floatValue] / 255.0;
        CGFloat blue = [components[2] floatValue] / 255.0;
        self.view.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
    }
    // 如果没有设置颜色，则使用默认的颜色
    else {
        self.view.backgroundColor = [UIColor lightGrayColor];
    }
}

%end
