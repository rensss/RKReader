//
//  RKChapter.h
//  Reader
//
//  Created by RZK on 2019/4/20.
//  Copyright © 2019 RZK. All rights reserved.
//

#import "RKModel.h"

@interface RKChapter : RKModel

@property (nonatomic, assign) NSInteger allPages; /**< 总页数*/
@property (nonatomic, assign) NSInteger page; /**< 当前页数*/
@property (nonatomic, copy) NSString *chapterName; /**< 章节名*/
@property (nonatomic, copy) NSString *content; /**< 内容*/

@end
