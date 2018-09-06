//
//  RKBook.m
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKBook.h"

@implementation RKBook

- (RKFile *)fileInfo {
    if (!_fileInfo) {
        _fileInfo = [RKFile new];
    }
    return _fileInfo;
}

@end
