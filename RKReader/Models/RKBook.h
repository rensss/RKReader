//
//  RKBook.h
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKModel.h"
#import "RKBookChapter.h"
#import "RKReadProgress.h"

@interface RKBook : RKModel

@property (nonatomic, copy) NSString *name; /**< 书名*/
@property (nonatomic, copy) NSString *content; /**< 内容*/
@property (nonatomic, copy) NSString *filePath; /**< 文件路径*/
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
 @param listBook 文件信息
 @return 书籍对象
 */
+ (instancetype)getLocalModelWithHomeBook:(RKHomeListBooks *)listBook;

@end
