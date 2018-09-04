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
@property (nonatomic, strong) NSURL *bookPath; /**< 书籍路径*/
@property (nonatomic, assign) CGFloat progress; /**< 阅读进度*/

@end
