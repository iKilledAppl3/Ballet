// always have a common header to keep your main header clean!
#import "Common.h"

// setting items
TSKSettingItem	*enableSwitch;
TSKSettingItem	*useImageWallpaperSwitch;
TSKSettingItem  *staticWallpaper;
TSKSettingItem	*useVideoWallpaperSwitch;
TSKSettingItem 	*videoWallpaper;
TSKSettingItem	*respringButton;
TSKSettingItem	*resetButton;

// plist path
#define PLIST_PATH @"/var/mobile/Library/Preferences/love.litten.balletpreferences.plist"

// loads the static wallpapers from a path and sets the screensaver to the plist file!
NSArray *wallpaperDirectory;

// loads the video wallpapers from a path and sets the screensaver to the plist file!
NSArray *videoDirectory;

// interface for prefs
@interface BLTRootListController : TSKViewController
@property (nonatomic,strong) UIBlurEffect* blur;
@property (nonatomic,strong) UIVisualEffectView* blurView;
- (void)resetPrompt;
- (void)resetPreferences;
- (void)doAFancyRespring;
- (void)respring;
- (void)setupCustomIcon;
@end

@interface NSTask : NSObject
@property(copy)NSArray* arguments;
@property(copy)NSString* currentDirectoryPath;
@property(copy)NSDictionary* environment;
@property(copy)NSString* launchPath;
@property(readonly)int processIdentifier;
@property(retain)id standardError;
@property(retain)id standardInput;
@property(retain)id standardOutput;
+ (id)currentTaskDictionary;
+ (id)launchedTaskWithDictionary:(id)arg1;
+ (id)launchedTaskWithLaunchPath:(id)arg1 arguments:(id)arg2;
- (id)init;
- (void)interrupt;
- (bool)isRunning;
- (void)launch;
- (bool)resume;
- (bool)suspend;
- (void)terminate;
@end


