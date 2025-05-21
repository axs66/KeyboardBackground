#import <CepheiPrefs/HBListController.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/CepheiPrefs.h>
#import <CepheiPrefs/PSListController+HBTintAdditions.h>
#import <spawn.h>

@interface KBTRootListController : HBListController
@end

@implementation KBTRootListController

- (instancetype)init {
    self = [super init];
    if (self) {
        // 从 Settings/KeyboardTheme.plist 加载设置面板内容
        [self loadFromSpecifierName:@"KeyboardTheme"];
    }
    return self;
}

- (void)respring {
    pid_t pid;
    const char *args[] = {"killall", "-9", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)args, NULL);
}

- (void)reloadTheme {
    CFNotificationCenterPostNotification(
        CFNotificationCenterGetDarwinNotifyCenter(),
        CFSTR("com.axs66.KeyboardTheme/ReloadTheme"),
        NULL,
        NULL,
        true
    );
}

@end

