#import "ThemeRootListController.h"
#import <notify.h>

@implementation ThemeRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"Root" target:self];
    }
    return _specifiers;
}

// 绑定按钮，发通知让 Tweak 重载配置
- (void)reloadTheme:(id)sender {
    int notify_token;
    notify_register_dispatch("com.keyboardtheme.reload", &notify_token, dispatch_get_main_queue(), ^(int token) {
        // nothing to do here
    });
    notify_post("com.keyboardtheme.reload");
}

@end
