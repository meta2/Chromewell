//
//  ChromeProfileFinder.m
//  Chromewell
//
//  Created by meta2 on 2016/02/07.
//  Copyright © 2016年 501dev.org. All rights reserved.
//

#import "ChromeProfileFinder.h"
#import "NSUserDefaults+Chromewell.h"

CF_ASSUME_NONNULL_BEGIN

@implementation ChromeProfileFinder {
    
    NSString *_profilesRootDir;
}

+ (instancetype)sharedFinder {
    static ChromeProfileFinder *sharedFinder = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedFinder = [[self alloc] init];
    });
    
    return sharedFinder;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *appSupportsDir = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES).firstObject;
        _profilesRootDir = [appSupportsDir stringByAppendingPathComponent:@"Google/Chrome"];
    }
    return self;
}

- (NSArray<ChromeProfile *> *)findProfiles {
    
    NSMutableArray<ChromeProfile *> *profiles = @[].mutableCopy;
    
    [self enumerateProfilesUsingBlock:^(NSString *name) {
        ChromeProfile *profile = [self findProfileWithName:name];
        if (profile) {
            [profiles addObject:profile];
        }
    }];
    
    NSSortDescriptor *sorter = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    return [profiles sortedArrayUsingDescriptors:@[sorter]];
}

- (ChromeProfile * _Nullable)findDefaultProfile {
    
    NSString *name = [NSUserDefaults standardUserDefaults].defaultProfileName;
    
    if (name) {
        return [self findProfileWithName:name];
    }
    
    return nil;
}

- (ChromeProfile * _Nullable)findProfileWithName:(NSString *)profileName {
    
    NSString *dir = [_profilesRootDir stringByAppendingPathComponent:profileName];
    
    NSString *displayName = [self loadDisplayNameWithProfileDirectory:dir];
    
    if (displayName) {
        return [[ChromeProfile alloc] initWithName:profileName displayName:displayName];
    }
    
    return nil;
}

- (NSString * _Nullable)loadDisplayNameWithProfileDirectory:(NSString *)profielDir {
    
    NSString *prefsFile = [profielDir stringByAppendingPathComponent:@"Preferences"];
    NSData *prefsData = [NSData dataWithContentsOfFile:prefsFile];
    
    if (prefsData == nil) {
        return nil;
    }
    
    NSDictionary *prefs = [NSJSONSerialization JSONObjectWithData:prefsData options:0 error:NULL];
    
    NSString *username = [prefs valueForKeyPath:@"profile.name"];
    
    return username;
}

- (void)enumerateProfilesUsingBlock:(void (^)(NSString *name))block {
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSDirectoryEnumerator *dirItr = [fm enumeratorAtPath:_profilesRootDir];
    NSString *name = nil;
    
    while ((name = dirItr.nextObject)) {
        if ([name isEqualToString:@"Default"] || [name hasPrefix:@"Profile"]) {
            block(name);
        }
        
        [dirItr skipDescendants];
    }
}

@end

CF_ASSUME_NONNULL_END
