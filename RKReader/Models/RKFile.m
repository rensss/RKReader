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
- (void)setFileName:(NSString *)fileName {
    _fileName = fileName;
    
    self.fileType = [[self.fileName componentsSeparatedByString:@"."] lastObject];
}

- (void)setFilePath:(NSString *)filePath {
	_filePath = filePath;
}

@end
