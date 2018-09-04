//
//  RKFileManager.m
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKFileManager.h"

@implementation RKFileManager

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
        BOOL isSuccess = [self createDir];
        if (!isSuccess) {
            RKLog(@"文件创建失败!  path=%@",kBookSavePath);
        }else {
            RKLog(@"文件创建成功!  path=%@",kBookSavePath);
        }
    }
    return self;
}

/// 创建书籍存放文件夹
- (BOOL)createDir {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir;
    // 先判断目录是否存在，不存在才创建
    if  (![fileManager fileExistsAtPath:kBookSavePath isDirectory:&isDir]) {
        BOOL res = [fileManager createDirectoryAtPath:kBookSavePath withIntermediateDirectories:YES attributes:nil error:nil];
        return res;
    } else {
        // 文件已存在
        return YES;
    }
}

#pragma mark - 函数
- (NSArray *)getBookList {
    NSMutableArray *array = [NSMutableArray array];
    
    
    
    return array;
}

@end
