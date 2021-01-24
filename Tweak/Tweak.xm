#import "Ballet.h"

%group BalletImage

%hook HBAppGridViewController

- (void)viewDidLoad { // add image wallpaper

	%orig;

	if (wallpaperView) return;

	wallpaperView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
	[wallpaperView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[wallpaperView setContentMode:UIViewContentModeScaleAspectFill];
	[wallpaperView setImage:[UIImage imageWithContentsOfFile:@"/Library/Ballet/wallpaper.png"]];
	[[self view] insertSubview:wallpaperView atIndex:0];

}

%end

%end

%group BalletVideo

%hook HBAppGridViewController

- (void)viewDidLoad { // add video wallpaper

	%orig;

	if (playerLayer) return;

	NSURL* url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"/Library/Ballet/wallpaper.mp4"]];

    playerItem = [AVPlayerItem playerItemWithURL:url];

    player = [AVQueuePlayer playerWithPlayerItem:playerItem];
    player.volume = 0.0;
	[player setPreventsDisplaySleepDuringVideoPlayback:NO];
	[[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryAmbient error:nil];

	playerLooper = [AVPlayerLooper playerLooperWithPlayer:player templateItem:playerItem];

    playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    [playerLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [playerLayer setFrame:[[[self view] layer] bounds]];
    [[[self view] layer] insertSublayer:playerLayer atIndex:0];

	[player play];

}

- (void)didFinishLaunchAnimationWithContext:(id)arg1 { // play when homescreen appeared

	%orig;

	[player play];

}

%end

%end

%group Ballet

%hook HBUIMainAppGridTopShelfContainerView

- (void)didMoveToWindow { // hide top shelf view

	%orig;

	[self removeFromSuperview];

}

%end

%end

static void loadPrefs() {

	NSMutableDictionary* preferences = [[NSMutableDictionary alloc] initWithContentsOfFile:@"/var/mobile/Library/Preferences/love.litten.balletpreferences.plist"];
  
	enabled = [([preferences objectForKey:@"Enabled"] ?: @(NO)) boolValue];

	useImageWallpaperSwitch = [([preferences objectForKey:@"useImageWallpaper"] ?: @(NO)) boolValue];
	useVideoWallpaperSwitch = [([preferences objectForKey:@"useVideoWallpaper"] ?: @(NO)) boolValue];

}

%ctor {

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) loadPrefs, CFSTR("love.litten.balletpreferences.update"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	loadPrefs();
	
	if (enabled) {
		%init(Ballet);
		if (useImageWallpaperSwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/Ballet/wallpaper.png"]) {
			%init(BalletImage);
			return;
		} else if (useVideoWallpaperSwitch && [[NSFileManager defaultManager] fileExistsAtPath:@"/Library/Ballet/wallpaper.mp4"]) {
			%init(BalletVideo);
			return;
		}
	}

}