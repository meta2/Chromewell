//
//  ChromeProfileFinder.h
//  Chromewell
//
//  Created by meta2 on 2016/02/07.
//  Copyright © 2016年 501dev.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChromeProfile.h"

CF_ASSUME_NONNULL_BEGIN

@interface ChromeProfileFinder : NSObject

+ (instancetype)sharedFinder;

- (NSArray<ChromeProfile *> *)findProfiles;

- (ChromeProfile * _Nullable)findDefaultProfile;

- (ChromeProfile * _Nullable)findProfileWithName:(NSString *)profileName;

@end

CF_ASSUME_NONNULL_END
