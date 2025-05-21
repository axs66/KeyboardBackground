#import <CepheiPrefs/CepheiPrefs.h>
#import <CepheiPrefs/CepheiPrefs-Swift.h>
#import <CepheiPrefs/HBAboutListController.h>
#import <CepheiPrefs/HBLinkTableCell.h>
#import <CepheiPrefs/HBListController.h>
#import <CepheiPrefs/HBMastodonTableCell.h>
#import <CepheiPrefs/HBPackageNameHeaderCell.h>
#import <CepheiPrefs/HBPackageTableCell.h>
#import <CepheiPrefs/HBRootListController.h>
#import <CepheiPrefs/HBStepperTableCell.h>
#import <CepheiPrefs/HBSupportController.h>
#import <CepheiPrefs/HBTintedTableCell.h>
#import <CepheiPrefs/HBTwitterCell.h>
#import <CepheiPrefs/PSListController+HBTintAdditions.h>
#import <spawn.h>

@interface KBTRootListController : HBListController
@end

@implementation KBTRootListController

// 不需要重写 init，Theos 会自动加载 KeyboardTheme.plist

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"KeyboardTheme" target:self];
    }
    return _specifiers;
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
