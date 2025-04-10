#import <Foundation/Foundation.h>

%hook YourClass

// 在这里使用 NSLog
NSLog(@"[SwipeInputTweak] Keyboard input detected: %@", arg1);

%end
