//
//  PreferencesWindowController.m
//  Chromewell
//
//  Created by meta2 on 2016/02/07.
//  Copyright © 2016年 501dev.org. All rights reserved.
//

#import "PreferencesWindowController.h"
#import "ChromeProfileFinder.h"
#import "NSUserDefaults+Chromewell.h"

static const NSInteger kAutomaticProfileTag = -1;

@interface PreferencesWindowController ()

@property (strong) IBOutlet NSButton *setDefaultBrowserButton;

@property (strong) IBOutlet NSTextField *defaultBrowserDescriptionField;

@property (strong) IBOutlet NSPopUpButton *profileSelectButton;

@end

@implementation PreferencesWindowController {
    
    NSUserDefaults *_userDefaults;

    NSArray<ChromeProfile *> *_profiles;
}

- (instancetype)init {
    self = [super initWithWindowNibName:@"PreferencesWindow"];
    if (self) {
        _userDefaults = [NSUserDefaults standardUserDefaults];
        _profiles = [[ChromeProfileFinder sharedFinder] findProfiles];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Configure setDefaultBrowserButton
    
    [self updateDefaultBrowserState];
    
    
    // Configure profileSelectButton
    
    NSString *defaultProfileName = _userDefaults.defaultProfileName;
    
    [_profiles enumerateObjectsUsingBlock:^(ChromeProfile * _Nonnull profile, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMenuItem *item = [[NSMenuItem alloc] initWithTitle:profile.displayName action:nil keyEquivalent:profile.displayName];
        item.tag = idx;
        [_profileSelectButton.menu addItem:item];
        
        if ([profile.name isEqualToString:defaultProfileName]) {
            [_profileSelectButton selectItem:item];
        }
    }];
}

- (void)updateDefaultBrowserState {
    
    NSString *bundleID = [NSBundle mainBundle].bundleIdentifier;
    
    NSString *defaultHandlerBundleID = (__bridge NSString *)(LSCopyDefaultHandlerForURLScheme(CFSTR("http")));
    
    if ([defaultHandlerBundleID compare:bundleID options:NSCaseInsensitiveSearch] != NSOrderedSame) {
        // Disabled
        _setDefaultBrowserButton.enabled = YES;
        _defaultBrowserDescriptionField.stringValue = NSLocalizedString(@"Change system default browser.", @"");
        
    } else {
        // Enabled
        _setDefaultBrowserButton.enabled = NO;
        _defaultBrowserDescriptionField.stringValue = NSLocalizedString(@"To disable, change Chrome's default browser settings.", @"");
    }
}


#pragma mark -

- (void)keyDown:(NSEvent *)event {
    
    if ((event.modifierFlags & NSDeviceIndependentModifierFlagsMask) == NSCommandKeyMask) {
        if ([event.characters isEqualToString:@"w"] || [event.characters isEqualToString:@"q"]) {
            [self.window close];
        }
    }
}

- (void)windowWillClose:(NSNotification *)notification {
    
    if (_closeHandler) {
        _closeHandler();
    }
}

- (void)windowDidBecomeMain:(NSNotification *)notification {
    [self updateDefaultBrowserState];
}

- (IBAction)clickedSetDefaultBrowserButton:(id)sender {
    
    NSString *bundleID = [NSBundle mainBundle].bundleIdentifier;

    LSSetDefaultHandlerForURLScheme(CFSTR("http"), (__bridge CFStringRef)bundleID);
}

- (IBAction)changedChromeUser:(id)sender {
 
    NSInteger index = _profileSelectButton.selectedItem.tag;
    
    if (index == kAutomaticProfileTag) {
        _userDefaults.defaultProfileName = nil;
        
    } else {
        _userDefaults.defaultProfileName = _profiles[index].name;
    }
}

@end
