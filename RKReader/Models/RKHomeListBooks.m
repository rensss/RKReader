//
//  RKHomeListBooks.m
//  RKReader
//
//  Created by MBP on 2018/9/11.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKHomeListBooks.h"

@implementation RKHomeListBooks

- (RKFile *)fileInfo {
    if (!_fileInfo) {
        _fileInfo = [RKFile new];
    }
    return _fileInfo;
}

@end
