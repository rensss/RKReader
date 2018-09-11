//
//  RKFile.m
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKFile.h"

@implementation RKFile

#pragma mark - setting
- (void)setFilePath:(NSString *)filePath {
	_filePath = filePath;
    
    // 子线程获取文件大小
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        self.fileSize = [[RKFileManager sharedInstance] getFileSize:filePath];
    });
}

@end
