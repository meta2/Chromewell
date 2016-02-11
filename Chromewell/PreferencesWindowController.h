//
//  PreferencesWindowController.h
//  Chromewell
//
//  Created by meta2 on 2016/02/07.
//  Copyright © 2016年 501dev.org. All rights reserved.
//

#import <Cocoa/Cocoa.h>

CF_ASSUME_NONNULL_BEGIN

@interface PreferencesWindowController : NSWindowController <NSWindowDelegate>

@property (nonatomic, copy, nullable) void (^closeHandler)();

@end

CF_ASSUME_NONNULL_END
