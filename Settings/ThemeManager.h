#import <UIKit/UIKit.h>

@interface ThemeManager : NSObject
@property (nonatomic, strong) NSDictionary *currentTheme;
+ (instancetype)sharedManager;
- (void)loadTheme;
@end
