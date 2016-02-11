//
//  NSUserDefaults+Chromewell.m
//  Chromewell
//
//  Created by meta2 on 2016/02/07.
//  Copyright © 2016年 501dev.org. All rights reserved.
//

#import "NSUserDefaults+Chromewell.h"

static NSString *const kDefaultProfileNameKey = @"defaultProfileName";

@implementation NSUserDefaults (Chromewell)

- (NSString *)defaultProfileName {
    return [self objectForKey:kDefaultProfileNameKey];
}

- (void)setDefaultProfileName:(NSString *)defaultProfileName {
    [self setObject:defaultProfileName forKey:kDefaultProfileNameKey];
}

@end
