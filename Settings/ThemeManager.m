#import "ThemeManager.h"

@implementation ThemeManager

+ (instancetype)sharedManager {
    static ThemeManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ThemeManager alloc] init];
        [manager loadThemeWithName:@"theme_default.json"];
    });
    return manager;
}

- (void)loadThemeWithName:(NSString *)themeFileName {
    NSString *path = [NSString stringWithFormat:@"/Library/Application Support/KeyboardTheme/%@", themeFileName];
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (!data) {
        // fallback to bundled resource
        path = [[NSBundle bundleForClass:self.class] pathForResource:[themeFileName stringByDeletingPathExtension] ofType:@"json"];
        data = [NSData dataWithContentsOfFile:path];
    }
    if (data) {
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
