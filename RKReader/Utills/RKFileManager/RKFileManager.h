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


@end
