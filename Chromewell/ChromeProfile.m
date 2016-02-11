//
//  ChromeProfile.m
//  Chromewell
//
//  Created by meta2 on 2016/02/07.
//  Copyright © 2016年 501dev.org. All rights reserved.
//

#import "ChromeProfile.h"

CF_ASSUME_NONNULL_BEGIN

@implementation ChromeProfile

- (instancetype)initWithName:(NSString *)name displayName:(NSString *)displayName {
    self = [super init];
    if (self) {
        _name = name;
        _displayName = displayName;
    }
    return self;
}

@end

CF_ASSUME_NONNULL_END
