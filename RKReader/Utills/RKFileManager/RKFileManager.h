//
//  RKFileManager.h
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKFileManager : NSObject

/**
 文件管理
 @return 单例
 */
+ (instancetype)sharedInstance;

/**
 返回书籍列表
 @return 书籍数组
 */
- (NSArray *)getBookList;

/**
 计算文件的大小，单位为 M
 @param path 文件路径
 @return 文件大小
 */
- (CGFloat)getFileSize:(NSString *)path;

@end
