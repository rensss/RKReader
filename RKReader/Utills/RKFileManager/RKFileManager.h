//
//  RKFileManager.h
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKBook;
@interface RKFileManager : NSObject

#pragma mark - init
/**
 初始化
 */
+ (void)fileManagerInit;

/**
 创建书籍存放文件夹
 @return 是否成功
 */
+ (BOOL)createDir;

#pragma mark - 首页数据
/**
 返回书籍列表
 @return 书籍数组
 */
+ (NSArray *)getBookList;

#pragma mark - 文件操作/缓存相关

/**
 删除单个文件
 @param filePath 文件路径
 */
+ (void)deleteFileWithFilePath:(NSString *)filePath;

/**
 删除单个缓存文件
 @param filePath 文件路径
 */
+ (void)deleteUserDefaultsDataWithFilePath:(NSString *)filePath;

/**
 删除全部书籍
 */
+ (void)clearAllBooks;

/**
 *  清除所有的存储本地的数据
 */
+ (void)clearAllUserDefaultsData;

#pragma mark - 数据解析

/**
 根据文件地址分配任务
 @param filePath 文件路径
 */
+ (void)threadedTaskAllocationWithFile:(NSString *)filePath;

/**
 更新首页列表数据
 @param isAdd 是否添加
 @param filePath 文件路径
 */
+ (void)updateHomeListData:(BOOL)isAdd filePath:(NSString *)filePath;

/**
 给书籍分出章节
 @param chapters 章节数组
 @param content 书籍内容
 */
+ (void)separateChapter:(NSMutableArray * __autoreleasing *)chapters content:(NSString *)content;

/**
 根据地址解码

 @param path 文件地址
 @return 文件内容
 */
+ (NSString *)encodeWithFilePath:(NSString *)path;

/**
 保存book信息
 @param book 书籍数据
 */
+ (void)archiverBookData:(RKBook *)book;

#pragma mark - 工具
/**
 计算文件的大小，单位为 M
 @param path 文件路径
 @return 文件大小
 */
+ (CGFloat)getFileSize:(NSString *)path;

@end
