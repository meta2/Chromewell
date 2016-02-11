//
//  AppDelegate.m
//  Chromewell
//
//  Created by meta2 on 2016/02/07.
//  Copyright © 2016年 501dev.org. All rights reserved.
//

#import "AppDelegate.h"
#import "ChromeAppAdapter.h"
#import "ChromeProfileFinder.h"
#import "PreferencesWindowController.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;

@property (nonatomic) PreferencesWindowController *prefsWC;

@end

@implementation AppDelegate {
    
    BOOL _isHandlingAppleEvent;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {

    if (_isHandlingAppleEvent == NO) {
        _prefsWC = [PreferencesWindowController new];
        
        _prefsWC.closeHandler = ^{
            [NSApp terminate:nil];
        };
        
        [_prefsWC showWindow:nil];
        
        [NSApp activateIgnoringOtherApps:YES];
    }
}

- (void)awakeFromNib {
    
    NSDictionary *options = @{
                              (__bridge NSString *)kAXTrustedCheckOptionPrompt: @(TRUE),
                              };
    if (AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef _Nullable)(options)) == FALSE) {
        NSLog(@"not trusted");
    }

    NSAppleEventManager *em = [NSAppleEventManager sharedAppleEventManager];
    
    [em setEventHandler:self
            andSelector:@selector(handleURLEvent:withReplyEvent:)
          forEventClass:kInternetEventClass
             andEventID:kAEGetURL];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
    
    NSString *url = [NSString stringWithFormat:@"file://%@", filename];
    
    [self handleOpenURL:url];
    
    return YES;
}

- (void)handleURLEvent:(NSAppleEventDescriptor *)event
        withReplyEvent:(NSAppleEventDescriptor *)replyEvent {
    
    NSString *url = [event paramDescriptorForKeyword:keyDirectObject].stringValue;

    [self handleOpenURL:url];
}

- (void)handleOpenURL:(NSString *)url {
    
    _isHandlingAppleEvent = YES;
    
    ChromeProfile *profile = [[ChromeProfileFinder sharedFinder] findDefaultProfile];
    
    NSLog(@"Open with %@ (%@) %@", profile.name, profile.displayName, url);
    
    [[ChromeAppAdapter new] openURL:url withProfile:profile];
    
    _isHandlingAppleEvent = NO;
    
    if ([self canTerminateApp]) {
        [NSApp terminate:self];
    }
}

- (BOOL)canTerminateApp {
    return (_prefsWC == nil);
}

@end
