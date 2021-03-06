//
//  RKBottomStatusBar.h
//  RKReader
//
//  Created by MBP on 2018/9/13.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKBottomStatusBar : UIView

@property (nonatomic, assign) NSInteger chapters; /**< 总章节数*/

@property (nonatomic, strong) RKHomeListBooks *book; /**< 书籍对象*/

/**
 初始化
 @param frame 大小
 @param chapter 当前章节
 @return 底部状态栏
 */
- (instancetype)initWithFrame:(CGRect)frame and:(RKBookChapter *)chapter;

@end
