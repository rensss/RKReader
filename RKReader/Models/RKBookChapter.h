//
//  RKBookChapter.h
//  RKReader
//
//  Created by RZK on 2018/9/8.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKModel.h"

@interface RKBookChapter : RKModel

@property (nonatomic, strong) NSString *content; /**< 章节内容*/
@property (nonatomic, strong) NSString *title; /**< 章节名称*/
@property (nonatomic, assign) NSInteger pageCount; /**< 页数*/
@property (nonatomic, assign) CGRect contentFrame; /**< 内容显示区域大小*/

/// 获取某页内容
- (NSString *)stringOfPage:(NSUInteger)index;

/// 修改字号
- (void)updateFont;

@end
