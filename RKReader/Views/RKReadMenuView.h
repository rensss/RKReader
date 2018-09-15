//
//  RKReadMenuView.h
//  RKReader
//
//  Created by MBP on 2018/9/14.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKReadMenuView : UIView

/**
 初始化菜单view
 @param frame 大小
 @param book 书籍信息
 @return 菜单
 */
- (instancetype)initWithFrame:(CGRect)frame withBook:(RKBook *)book;

#pragma mark - 函数
/**
 显示
 @param superView 父view
 */
- (void)showToView:(UIView *)superView;

/**
 消失的回调
 @param handler 回调
 */
- (void)dismissBlock:(void(^)(void))handler;

@end
