#import "BLTRootListController.h"

inline NSString* GetPrefVal(NSString* key){
    return [[NSDictionary dictionaryWithContentsOfFile:PLIST_PATH] valueForKey:key];
}

@implementation BLTRootListController

- (id)loadSettingGroups {

    // setup the fancy animation 
    [self setupCustomIcon];

    id facade = [[NSClassFromString(@"TVSettingsPreferenceFacade") alloc] initWithDomain:@"love.litten.balletpreferences" notifyChanges:TRUE];
    
    videoDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Documents/Ethereal/" error:NULL];
    wallpaperDirectory = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:@"/var/mobile/Documents/AirPhoto/" error:NULL];

    NSMutableArray* _backingArray = [NSMutableArray new];
    
    // enable
    enableSwitch = [TSKSettingItem toggleItemWithTitle:@"Enabled" description:@"" representedObject:facade keyPath:@"Enabled" onTitle:@"Enabled" offTitle:@"Disabled"];

    // settings
    useImageWallpaperSwitch = [TSKSettingItem toggleItemWithTitle:@"Use Image Wallpaper" description:@"" representedObject:facade keyPath:@"useImageWallpaper" onTitle:@"Enabled" offTitle:@"Disabled"];
    // loads from the directory and applies them to the tweak
    staticWallpaper = [TSKSettingItem multiValueItemWithTitle:@"Choose Image" description:@"Choose your static wallpaper. \n You can AirDrop them to AirPhoto and select them here." representedObject:facade keyPath:@"chosenWallpaper" availableValues:wallpaperDirectory];

    useVideoWallpaperSwitch = [TSKSettingItem toggleItemWithTitle:@"Use Video Wallpaper" description:@"" representedObject:facade keyPath:@"useVideoWallpaper" onTitle:@"Enabled" offTitle:@"Disabled"];
     // loads from the directory and applies them to the tweak
    videoWallpaper = [TSKSettingItem multiValueItemWithTitle:@"Choose Video" description:@"Choose your video wallpaper. \n You can AirDrop them to Ethereal and select them here." representedObject:facade keyPath:@"chosenVideoWallpaper" availableValues:videoDirectory];

    // other options
    respringButton = [TSKSettingItem actionItemWithTitle:@"Respring" description:@"" representedObject:facade keyPath:PLIST_PATH target:self action:@selector(doAFancyRespring)];
    resetButton = [TSKSettingItem actionItemWithTitle:@"Reset Preferences" description:@"" representedObject:facade keyPath:PLIST_PATH target:self action:@selector(resetPrompt)];
    
    // settings groups always stay together
    TSKSettingGroup* enableGroup = [TSKSettingGroup groupWithTitle:@"Enable" settingItems:@[enableSwitch]];
    TSKSettingGroup* settingsGroup = [TSKSettingGroup groupWithTitle:@"Staic Wallpaper" settingItems:@[useImageWallpaperSwitch, staticWallpaper]];
    TSKSettingGroup *settingsGroup2 = [TSKSettingGroup groupWithTitle:@"Video Wallpaper" settingItems:@[useVideoWallpaperSwitch, videoWallpaper]];
    TSKSettingGroup* otherOptionsGroup = [TSKSettingGroup groupWithTitle:@"Other Options" settingItems:@[respringButton, resetButton]];

    // add the settings groups to the backing array
     [_backingArray addObject:enableGroup];
     [_backingArray addObject:settingsGroup];
     [_backingArray addObject:settingsGroup2];
     [_backingArray addObject:otherOptionsGroup];

    [self setValue:_backingArray forKey:@"_settingGroups"];
    
    return _backingArray;

    [self setupCustomIcon];
    
}


// move this to its own method to make it more clean!
- (void)setupCustomIcon {
        // gradient and custom icon
    NSString* imagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"preferencesIcon" ofType:@"png"];
    UIImage* icon = [UIImage imageWithContentsOfFile:imagePath];
    if (icon != nil) {
        UIImageView* iconView = [[UIImageView alloc] initWithImage:icon];
        [iconView setContentMode:UIViewContentModeScaleAspectFit];
        iconView.clipsToBounds = YES;
        iconView.layer.cornerRadius = 5.0;
        [iconView setAlpha:0.0];
        [iconView setTransform:CGAffineTransformMakeScale(0.9, 0.9)];

        [iconView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [iconView.widthAnchor constraintEqualToConstant:512].active = YES;
        [iconView.heightAnchor constraintEqualToConstant:512].active = YES;
        if (![iconView isDescendantOfView:[self view]]) [[self view] addSubview:iconView];
        [iconView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor constant:-425].active = YES;
        [iconView.centerYAnchor constraintEqualToAnchor:self.view.centerYAnchor constant:-32].active = YES;

        [UIView animateWithDuration:0.5 delay:0.8 usingSpringWithDamping:300 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [iconView setAlpha:1.0];
            [iconView setTransform:CGAffineTransformMakeScale(1, 1)];
        } completion:nil];


        CAGradientLayer* gradient = [[CAGradientLayer alloc] init];
        [gradient setFrame:[[self view] bounds]];
        [gradient setStartPoint:CGPointMake(0.0, 0.5)];
        [gradient setEndPoint:CGPointMake(1.0, 0.5)];
        [gradient setColors:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed: 1.00 green: 0.92 blue: 0.94 alpha: 1.00] CGColor], (id)[[UIColor colorWithRed: 1.00 green: 0.72 blue: 0.79 alpha: 1.00] CGColor], (id)[[UIColor colorWithRed: 1.00 green: 0.52 blue: 0.64 alpha: 1.00] CGColor], nil]];
        [gradient setLocations:[NSArray arrayWithObjects:@(-0.5), @(1.5), nil]];
            
        CABasicAnimation* animation = [[CABasicAnimation alloc] init];
        [animation setKeyPath:@"colors"];
        [animation setFromValue:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed: 1.00 green: 0.92 blue: 0.94 alpha: 1.00] CGColor], (id)[[UIColor colorWithRed: 1.00 green: 0.72 blue: 0.79 alpha: 1.00] CGColor], (id)[[UIColor colorWithRed: 1.00 green: 0.52 blue: 0.64 alpha: 1.00] CGColor], nil]];
        [animation setToValue:[NSArray arrayWithObjects:(id)[[UIColor colorWithRed: 1.00 green: 0.52 blue: 0.64 alpha: 1.00] CGColor], (id)[[UIColor colorWithRed: 1.00 green: 0.72 blue: 0.79 alpha: 1.00] CGColor], (id)[[UIColor colorWithRed: 1.00 green: 0.92 blue: 0.94 alpha: 1.00] CGColor], nil]];
        [animation setDuration:5.0];
        [animation setAutoreverses:YES];
        [animation setRepeatCount:INFINITY];

        [gradient addAnimation:animation forKey:nil];
        [[[self view] layer] insertSublayer:gradient atIndex:0];
    }

}


- (void)resetPrompt {

    UIAlertController* resetAlert = [UIAlertController alertControllerWithTitle:@"Ballet"
	message:@"Do You Really Want To Reset Your Preferences?"
	preferredStyle:UIAlertControllerStyleActionSheet];
	
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"Yaw" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* action) {
        [self resetPreferences];
	}];

	UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"Naw" style:UIAlertActionStyleCancel handler:nil];

	[resetAlert addAction:confirmAction];
	[resetAlert addAction:cancelAction];

	[self presentViewController:resetAlert animated:YES completion:nil];

}

- (void)resetPreferences {

    [[NSFileManager defaultManager] removeItemAtPath:@"/var/mobile/Library/Preferences/love.litten.balletpreferences.plist" error:nil];
    
    [self doAFancyRespring];

}

- (void)doAFancyRespring {

    self.blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    self.blurView = [[UIVisualEffectView alloc] initWithEffect:self.blur];
    [self.blurView setFrame:self.view.bounds];
    [self.blurView setAlpha:0.0];
    [[self view] addSubview:self.blurView];

    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.blurView setAlpha:1.0];
    } completion:^(BOOL finished) {
        [self respring];
    }];

}

- (void)respring {

    NSTask  *task = [[[NSTask alloc] init] autorelease];
    [task setLaunchPath:@"/usr/bin/killall"];
    [task setArguments:[NSArray arrayWithObjects:@"backboardd", nil]];
    [task launch];

}

- (TVSPreferences *)ourPreferences {

    return [TVSPreferences preferencesWithDomain:@"love.litten.balletpreferences"];

}

- (void)showViewController:(TSKSettingItem *)item {

    TSKTextInputViewController* testObject = [[TSKTextInputViewController alloc] init];
    
    testObject.headerText = @"Ballet";
    testObject.initialText = [[self ourPreferences] stringForKey:item.keyPath];
    
    if ([testObject respondsToSelector:@selector(setEditingDelegate:)])
        [testObject setEditingDelegate:self];

    [testObject setEditingItem:item];
    [self.navigationController pushViewController:testObject animated:TRUE];

}

- (id)previewForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    TSKPreviewViewController* item = [super previewForItemAtIndexPath:indexPath];
    
    NSString* imagePath = [[NSBundle bundleForClass:self.class] pathForResource:@"icon" ofType:@"png"];
    UIImage* icon = [UIImage imageWithContentsOfFile:imagePath];
    if (icon != nil) {
        TSKVibrantImageView* imageView = [[TSKVibrantImageView alloc] initWithImage:icon];
        imageView.clipsToBounds = YES;
        imageView.layer.cornerRadius = 5.0;
        [item setContentView:imageView];
    }

    return item;
    
}

@end
