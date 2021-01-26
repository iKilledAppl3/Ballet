#import "Ballet.h"

// regular wallpaper
%group BalletImage
%hook HBAppGridViewController

- (void)viewDidLoad { // add image wallpaper

	%orig;

	if (wallpaperView) return;

	wallpaperView = [[UIImageView alloc] initWithFrame:[[self view] bounds]];
	[wallpaperView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
	[wallpaperView setContentMode:UIViewContentModeScaleAspectFill];
	// user selected image from AirDrop location
	[wallpaperView setImage:[UIImage imageWithContentsOfFile:wallpaperPath]];
	[[self view] insertSubview:wallpaperView atIndex:0];

}

%end
%end


// video wallpaper 
%group BalletVideo
%hook HBAppGridViewController

- (void)viewDidLoad { // add video wallpaper

	%orig;

	if (playerLayer) return;

	// when user selects video from AirDropped location
	NSURL* url = [NSURL fileURLWithPath:videoPath];

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

	NSMutableDictionary	*prefs = [[NSMutableDictionary alloc] initWithContentsOfFile:PLIST_PATH];
  
	enabled = [([prefs objectForKey:@"Enabled"] ?: @(NO)) boolValue];

	useImageWallpaperSwitch = [([prefs objectForKey:@"useImageWallpaper"] ?: @(NO)) boolValue];
	useVideoWallpaperSwitch = [([prefs objectForKey:@"useVideoWallpaper"] ?: @(NO)) boolValue];
	
	chosenWallpaper = [prefs objectForKey:@"chosenWallpaper"];
	chosenVideoWallpaper = [prefs objectForKey:@"chosenVideoWallpaper"];

}

%ctor {

	CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback) loadPrefs, CFSTR("love.litten.balletpreferences.update"), NULL, CFNotificationSuspensionBehaviorDeliverImmediately);
	loadPrefs();
	
	if (enabled) {
		%init(Ballet);
		if (useImageWallpaperSwitch) {
			%init(BalletImage);
			return;
		} else if (useVideoWallpaperSwitch) {
			%init(BalletVideo);
			return;
		}
	}

}