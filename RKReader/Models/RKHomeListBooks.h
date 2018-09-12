//
//  RKHomeListBooks.h
//  RKReader
//
//  Created by MBP on 2018/9/11.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKModel.h"
#import "RKFile.h"

@interface RKHomeListBooks : RKModel

@property (nonatomic, copy) NSString *key; /**< 保存的key|书名生成的MD5加密值*/
@property (nonatomic, copy) NSString *coverName; /**< 封面图名称*/
@property (nonatomic, strong) RKFile *fileInfo; /**< 书籍基本信息*/
@property (nonatomic, strong) RKReadProgress *readProgress; /**< 阅读进度*/

@end
