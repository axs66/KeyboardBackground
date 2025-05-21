#import "KBTRootListController.h"
#import <Preferences/PSSpecifier.h>

@implementation KBTRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [[self loadSpecifiersFromPlistName:@"KeyboardTheme" target:self] retain];

        PSSpecifier *themePicker = [PSSpecifier preferenceSpecifierNamed:@"当前主题"
                                                                     target:self
                                                                        set:@selector(setPreferenceValue:specifier:)
                                                                        get:@selector(readPreferenceValue:)
                                                                     detail:nil
                                                                       cell:PSPopupCell
                                                                       edit:nil];
        [themePicker setProperty:@"ThemeName" forKey:@"key"];
        [themePicker setValues:@[@"default", @"dark"] titles:@[@"默认", @"深色"]];
        [_specifiers addObject:themePicker];
    }
    return _specifiers;
}

- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.yourcompany.keyboardtheme.plist"];
    return settings[specifier.properties[@"key"]] ?: @"default";
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithContentsOfFile:@"/var/mobile/Library/Preferences/com.yourcompany.keyboardtheme.plist"] ?: [NSMutableDictionary dictionary];
    settings[specifier.properties[@"key"]] = value;
    [settings writeToFile:@"/var/mobile/Library/Preferences/com.yourcompany.keyboardtheme.plist" atomically:YES];

    // 通知热重载
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.yourcompany.keyboardtheme/reload"), NULL, NULL, YES);
}

@end
