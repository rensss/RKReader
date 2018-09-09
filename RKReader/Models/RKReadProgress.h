//
//  RKReadProgress.h
//  RKReader
//
//  Created by RZK on 2018/9/9.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKModel.h"

@interface RKReadProgress : RKModel

@property (nonatomic, assign) CGFloat progress; /**< 阅读进度 百分比*/
@property (nonatomic, copy) NSString *title; /**< 章节名*/
@property (nonatomic, assign) NSInteger chapter; /**< 章节*/
@property (nonatomic, assign) NSInteger page; /**< 页码*/

@end
