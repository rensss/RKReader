//
//  RKBook.h
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKModel.h"

@interface RKBook : RKModel

@property (nonatomic, copy) NSString *name; /**< 书名*/
@property (nonatomic, assign) CGFloat progress; /**< 阅读进度*/
@property (nonatomic, copy) NSString *coverName; /**< 封面图*/
@property (nonatomic, strong) RKFile *fileInfo; /**< 文件信息*/

@end
