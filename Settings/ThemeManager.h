#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ThemeManager : NSObject

@property (nonatomic, strong) NSDictionary *themeConfig;

+ (instancetype)sharedManager;
- (void)loadThemeWithName:(NSString *)themeFileName;
- (UIColor *)colorForKey:(NSString *)key;
- (NSString *)stringForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
