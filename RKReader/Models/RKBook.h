//
//  RKBook.h
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKModel.h"
#import "RKBookChapter.h"

@interface RKBook : RKModel

@property (nonatomic, copy) NSString *name; /**< 书名*/
@property (nonatomic, copy) NSString *content; /**< 内容*/
@property (nonatomic, assign) CGFloat progress; /**< 阅读进度*/
@property (nonatomic, copy) NSString *coverName; /**< 封面图*/
@property (nonatomic, strong) RKFile *fileInfo; /**< 文件信息*/
@property (nonatomic, strong) NSMutableArray <RKBookChapter *>*chapters; /**< 章节数据*/

/**
 初始化
 @param content 内容
 @return 书籍对象
 */
- (instancetype)initWithContent:(NSString *)content;


#pragma mark - 类方法

/**
 根据初始化
 @param url 地址
 @return 书籍对象
 */
+ (instancetype)getLocalModelWithURL:(NSURL *)url;


@end
