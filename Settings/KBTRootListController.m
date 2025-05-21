#import <Cephei/HBPreferences.h>
#import <CepheiUI/HBListController.h>
#import <spawn.h>

@interface KBTRootListController : HBListController
@end

@implementation KBTRootListController

- (instancetype)init {
    self = [super init];
    if (self) {
        // 加载 Settings/KeyboardTheme.plist
        [self loadFromSpecifierPlistName:@"KeyboardTheme"];
    }
    return self;
}

- (void)respring {
    pid_t pid;
    const char *args[] = {"killall", "-9", "SpringBoard", NULL};
    posix_spawn(&pid, "/usr/bin/killall", NULL, NULL, (char *const *)args, NULL);
}

- (void)reloadTheme {
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.axs66.KeyboardTheme/ReloadTheme"), NULL, NULL, true);
}

@end
