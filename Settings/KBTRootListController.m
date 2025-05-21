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
        [self loadFromSpecifierPlistName:@"KeyboardTheme"];
    }
    return self;
}

// 触发重启 SpringBoard，用于应用设置更改
- (void)respring {
    pid_t pid;
    const char *args[] = {"killall", "-9", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)args, NULL);
}

// 发送通知，触发主题重载（供其他模块监听）
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
