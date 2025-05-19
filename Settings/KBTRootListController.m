#import "KBTRootListController.h"
#import <Preferences/PSListController.h>
#import <Preferences/PSSpecifier.h>


@implementation KBTRootListController

- (NSArray *)specifiers {
    if (!_specifiers) {
        _specifiers = [self loadSpecifiersFromPlistName:@"KeyboardTheme" target:self];
    }
    return _specifiers;
}
@end
