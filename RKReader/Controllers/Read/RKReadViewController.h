//
//  RKReadViewController.h
//  RKReader
//
//  Created by MBP on 2018/9/6.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKViewController.h"
#import "RKReadView.h"

@interface RKReadViewController : RKViewController

@property (nonatomic, strong) RKHomeListBooks *listBook; /**< 当前书籍*/
@property (nonatomic, strong) RKBookChapter *bookChapter; /**< 当前章节对象*/
@property (nonatomic, assign) NSInteger chapters; /**< 总共章节数*/

@property (nonatomic, strong) RKReadView *readView; /**< 文字内容view*/
@property (nonatomic, copy) NSString *content; /**< 显示内容*/
@property (nonatomic, assign) NSInteger chapter; /**< 章节*/
@property (nonatomic, assign) NSInteger page; /**< 页码*/

@end
