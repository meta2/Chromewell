//
//  ChromeAppAdapter.h
//  Chromewell
//
//  Created by meta2 on 2016/02/07.
//  Copyright © 2016年 501dev.org. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChromeProfile.h"

CF_ASSUME_NONNULL_BEGIN

@interface ChromeAppAdapter : NSObject

- (void)openURL:(NSString *)url withProfile:(ChromeProfile * _Nullable)profile;

@end

CF_ASSUME_NONNULL_END
