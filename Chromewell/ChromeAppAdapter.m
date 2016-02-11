//
//  ChromeAppAdapter.m
//  Chromewell
//
//  Created by meta2 on 2016/02/07.
//  Copyright © 2016年 501dev.org. All rights reserved.
//

#import "ChromeAppAdapter.h"
#import <ScriptingBridge/ScriptingBridge.h>
#import "SystemEvents.h"
#import "GoogleChrome.h"

CF_ASSUME_NONNULL_BEGIN

@implementation ChromeAppAdapter {
    
    SystemEventsApplicationProcess *_process;
    
    GoogleChromeApplication *_app;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        SystemEventsApplication *systemEvents = [SBApplication applicationWithBundleIdentifier:@"com.apple.systemevents"];
        
        _process = [systemEvents.applicationProcesses objectWithName:@"Google Chrome"];
        
        _app = [SBApplication applicationWithBundleIdentifier:@"com.google.Chrome"];
    }
    return self;
}

#pragma mark -

- (void)openURL:(NSString *)url withProfile:(ChromeProfile * _Nullable)profile {

    [self activate];

    if (_app.windows.count == 0) {
        sleep(2); // 2s
    }
    
    if (profile) {
        [self selectProfile:profile];
        usleep(200 * 1000); // 200ms
    }
    
    [self openURL:url];
}

- (void)activate {
    [_app activate];
}

- (BOOL)selectProfile:(ChromeProfile *)profile {
    
    NSArray<SystemEventsMenu *> *menus = _process.menuBars.firstObject.menus;
    
    SystemEventsMenu *usersMenu = menus[menus.count - 3];
    
    for (SystemEventsMenuItem *item in usersMenu.menuItems) {
        if (item.name.length == 0) {
            // separator
            break;
        }
        
        if ([item.name isEqualToString:profile.displayName]) {
            [item clickAt:@[]];
            return YES;
        }
    }
    
    NSLog(@"no profile");
    
    return NO;
}

- (void)openURL:(NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString:urlString];
    
    if (url) {
        [[NSWorkspace sharedWorkspace] openURLs:@[ url ]
                        withAppBundleIdentifier:@"com.google.Chrome"
                                        options:NSWorkspaceLaunchDefault
                 additionalEventParamDescriptor:nil
                              launchIdentifiers:nil];
    }
}

@end

CF_ASSUME_NONNULL_END
