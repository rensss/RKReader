//
//  RKFileManager.h
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RKBook,RKHomeListBooks;
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

#pragma mark - 文件操作/缓存相关
#pragma mark -- 增
/**
 根据路径生成model,然后保存
 @param filePath 文件路径
 */
+ (void)addFileWithFilePath:(NSString *)filePath;

/**
 添加首页列表数据
 @param book 列表书籍数据
 */
+ (void)saveHomeListWithListBook:(RKHomeListBooks *)book;

/**
 保存首页列表
 @param homeList 列表数据
 */
+ (void)saveHomeList:(NSMutableArray *)homeList;


#pragma mark -- 删
/**
 删除单个文件
 @param filePath 文件路径
 */
+ (void)deleteFileWithFilePath:(NSString *)filePath;

/**
 删除单个书籍
 @param book 书籍数据
 */
+ (void)deleteHomeListWithHomeList:(RKHomeListBooks *)book;

/**
 删除全部首页列表数据
 */
+ (void)deleteAllHomeList;

/**
 删除单个缓存文件
 @param filePath 文件路径
 */
+ (void)deleteUserDefaultsDataWithFilePath:(NSString *)filePath;

#pragma mark -- 改
/**
 更新首页列表数据
 @param isAdd 是否添加
 @param filePath 文件路径
 */
+ (void)updateHomeListData:(BOOL)isAdd filePath:(NSString *)filePath;

#pragma mark -- 查
/**
 获取首页列表书籍数据
 */
+ (NSMutableArray <RKHomeListBooks *> *)getHomeListBooks;

#pragma mark -- 缓存管理
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
