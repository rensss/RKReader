//
//  RKReadViewController.h
//  RKReader
//
//  Created by MBP on 2018/9/6.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKViewController.h"

@interface RKReadViewController : RKViewController

@property (nonatomic, copy) NSString *content; /**< 显示内容*/
@property (nonatomic, assign) NSInteger chapter; /**< 章节*/
@property (nonatomic, assign) NSInteger page; /**< 页码*/

@end
