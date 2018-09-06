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
        if ([[dict allKeys] containsObject:kUserConfigHomeCoverKey]) {
            self.homeCoverWidth = [dict[kUserConfigHomeCoverKey] floatValue];
        } else {
            self.homeCoverWidth = 80.0f;
        }
    }
    return self;
}


#pragma mark - 函数
/**
 保存当前用户配置
 */
- (void)saveUserConfig {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.homeCoverWidth) forKey:kUserConfigHomeCoverKey];
    
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:kUserConfigutationPATH error:&error];
    if (error) {
        RKLog(@"%@",error);
    }
    [NSKeyedArchiver archiveRootObject:dict toFile:kUserConfigutationPATH];
}

@end
