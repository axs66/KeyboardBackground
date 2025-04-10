#import <Foundation/Foundation.h>

%hook YourClass

// 假设 arg1 是一个 NSString 类型的变量
NSString *arg1 = @"Sample Input";  // 为了示例初始化，实际代码需要替换成合适的参数

// 在这里使用 NSLog 打印信息
NSLog(@"[SwipeInputTweak] Keyboard input detected: %@", arg1);

%end
