//
//  RKFile.h
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKModel.h"

@interface RKFile : RKModel

@property (nonatomic, strong) NSString *fileName; /**< 文件名*/
@property (nonatomic, strong) NSString *filePath; /**< 文件路径*/
@property (nonatomic, strong) NSString *fileType; /**< 文件类型*/
@property (nonatomic, assign) CGFloat fileSize; /**< 文件大小*/

@end
