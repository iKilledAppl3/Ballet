// headers
@import UIKit;
@import Foundation;
@import AVFoundation;

// user switches
BOOL enabled;
BOOL useImageWallpaperSwitch;
BOOL useVideoWallpaperSwitch;

// strings needed when user selects a video or static wallpaper image
NSString *chosenWallpaper;
NSString *chosenVideoWallpaper;

// Load our videowallpapers with the Power of AirDrop and Ethereal!
#define videoPath [NSString stringWithFormat:@"/var/mobile/Documents/Ethereal/%@", chosenVideoWallpaper]
#define wallpaperPath [NSString stringWithFormat:@"/var/mobile/Documents/AirPhoto/%@", chosenWallpaper]

// preferences plist using macros
#define PLIST_PATH @"/var/mobile/Library/Preferences/love.litten.balletpreferences.plist"

// wallpaper stuff
UIImageView* wallpaperView;
AVQueuePlayer* player;
AVPlayerItem* playerItem;
AVPlayerLooper* playerLooper;
AVPlayerLayer* playerLayer;

// apple intreface views
@interface HBAppGridViewController : UIViewController
@end

@interface HBUIMainAppGridTopShelfContainerView : UIView
@end

@interface HBBadgeOverlayView : UIView
@end