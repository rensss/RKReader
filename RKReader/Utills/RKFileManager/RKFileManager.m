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

#pragma mark - 函数
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
#pragma mark -- 公用函数
- (NSArray *)getBookList {
    NSMutableArray *array = [NSMutableArray array];
    
    NSFileManager *manager = [NSFileManager defaultManager];
    //获取数据
    //①只获取文件名
    NSArray *fileNameArray = [NSMutableArray arrayWithArray:[manager contentsOfDirectoryAtPath:kBookSavePath error:nil]];
    
    for (NSString *fileName in fileNameArray) {
        RKFile *file = [RKFile new];
        file.fileName = fileName;
        file.filePath = [NSString stringWithFormat:@"%@/%@",kBookSavePath,fileName];
        file.fileType = [[fileName componentsSeparatedByString:@"."] lastObject];
        file.fileSize = [self getFileSize:file.filePath];

        [array addObject:file];
    }
    
    return array;
}

/// 计算文件的大小，单位为 M
- (CGFloat)getFileSize:(NSString *)path {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    float filesize = -1.0;
    if ([fileManager fileExistsAtPath:path]) {
        NSDictionary *fileDic = [fileManager attributesOfItemAtPath:path error:nil];//获取文件的属性
        unsigned long long size = [[fileDic objectForKey:NSFileSize] longLongValue];
        filesize = size/1000.0/1000.0;
    }
    return filesize;
}

@end
