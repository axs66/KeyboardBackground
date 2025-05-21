#import <Foundation/Foundation.h>

@interface ThemeManager : NSObject

+ (instancetype)sharedManager;

- (void)reloadConfig;
- (NSDictionary *)currentConfig;

@end
