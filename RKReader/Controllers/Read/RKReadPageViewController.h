//
//  RKReadPageViewController.h
//  RKReader
//
//  Created by MBP on 2018/9/6.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKViewController.h"

@interface RKReadPageViewController : RKViewController

@property (nonatomic, strong) RKHomeListBooks *listBook; /**< 首页书籍对象*/
@property (nonatomic, strong) RKBook *book; /**< 当前书籍*/

@end
