//
//  ChromeProfile.h
//  Chromewell
//
//  Created by meta2 on 2016/02/07.
//  Copyright © 2016年 501dev.org. All rights reserved.
//

#import <Foundation/Foundation.h>

CF_ASSUME_NONNULL_BEGIN

@interface ChromeProfile : NSObject

@property (readonly, nonatomic) NSString *name;

@property (readonly, nonatomic) NSString *displayName;

- (instancetype)initWithName:(NSString *)name displayName:(NSString *)displayName;

@end

CF_ASSUME_NONNULL_END
