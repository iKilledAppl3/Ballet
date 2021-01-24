#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

BOOL enabled = NO;

UIImageView* wallpaperView;
AVQueuePlayer* player;
AVPlayerItem* playerItem;
AVPlayerLooper* playerLooper;
AVPlayerLayer* playerLayer;

BOOL useImageWallpaperSwitch = NO;
BOOL useVideoWallpaperSwitch = NO;

@interface HBAppGridViewController : UIViewController
@end

@interface HBUIMainAppGridTopShelfContainerView : UIView
@end

@interface HBBadgeOverlayView : UIView
@end