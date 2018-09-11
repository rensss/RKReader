//
//  RKFileManager.h
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

@interface RKFileManager : NSObject

/**
 文件管理
 @return 单例
 */
+ (instancetype)sharedInstance;

#pragma mark - 函数
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

/**
 删除全部书籍
 */
- (void)clearAllBooks;

/**
 *  清除所有的存储本地的数据
 */
- (void)clearAllUserDefaultsData;

#pragma mark - 类函数

/**
 给书籍分出章节
 @param chapters 章节数组
 @param content 书籍内容
 */
+ (void)separateChapter:(NSMutableArray * __autoreleasing *)chapters content:(NSString *)content;

/**
 根据地址解码
 @param url 地址
 @return 内容
 */
+ (NSString *)encodeWithURL:(NSURL *)url;


/**
 根据内容返回CTFrameRef

 @param content 内容
 @return CTFrameRef
 */
+ (CTFrameRef)parserContent:(NSString *)content;

@end
