//
//  RKUserConfiguration.m
//  RKReader
//
//  Created by MBP on 2018/9/6.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKUserConfiguration.h"

@implementation RKUserConfiguration

+ (instancetype)sharedInstance
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:kUserConfigutationPATH];
        NSMutableDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        
        if ([[dict allKeys] containsObject:kUserConfigHomeCoverWidth]) {
            self.homeCoverWidth = [dict[kUserConfigHomeCoverWidth] floatValue];
        } else {
            self.homeCoverWidth = 80.0f;
        }
        if ([[dict allKeys] containsObject:kUserConfigTransitionStyle]) {
            self.transitionStyle = [dict[kUserConfigTransitionStyle] integerValue];
        }else {
            self.transitionStyle = UIPageViewControllerTransitionStylePageCurl;
        }
        if ([[dict allKeys] containsObject:kUserConfigNavigationOrientation]) {
            self.navigationOrientation = [dict[kUserConfigNavigationOrientation] integerValue];
        }else {
            self.navigationOrientation = UIPageViewControllerNavigationOrientationHorizontal;
        }
        if ([[dict allKeys] containsObject:kUserConfigBottomStatusHeight]) {
            self.bottomPadding = [dict[kUserConfigBottomStatusHeight] floatValue];
        }else {
            self.bottomPadding = 10.0f;
        }
        if ([[dict allKeys] containsObject:kUserConfigTopPadding]) {
            self.topPadding = [dict[kUserConfigTopPadding] floatValue];
        }else {
            self.topPadding = 10.0f;
        }
        if ([[dict allKeys] containsObject:kUserConfigLeftPadding]) {
            self.leftPadding = [dict[kUserConfigLeftPadding] floatValue];
        }else {
            self.leftPadding = 10.0f;
        }
        if ([[dict allKeys] containsObject:kUserConfigBottomPadding]) {
            self.bottomPadding = [dict[kUserConfigBottomPadding] floatValue];
        }else {
            self.bottomPadding = 10.0f;
        }
        if ([[dict allKeys] containsObject:kUserConfigRightPadding]) {
            self.rightPadding = [dict[kUserConfigRightPadding] floatValue];
        }else {
            self.rightPadding = 10.0f;
        }
        
        // 保存默认值
        [self saveUserConfig];
    }
    return self;
}


#pragma mark - 函数
/**
 保存当前用户配置
 */
- (void)saveUserConfig {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.homeCoverWidth) forKey:kUserConfigHomeCoverWidth];
    [dict setValue:@(self.transitionStyle) forKey:kUserConfigTransitionStyle];
    [dict setValue:@(self.navigationOrientation) forKey:kUserConfigNavigationOrientation];
    
    // 删除旧版本
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:kUserConfigutationPATH error:&error];
    if (error) {
        RKLog(@"删除用户配置失败 -- %@",error);
    }
    // 保存新版本
    [NSKeyedArchiver archiveRootObject:dict toFile:kUserConfigutationPATH];
}

@end
