//
//  RKReadMenuView.h
//  RKReader
//
//  Created by MBP on 2018/9/14.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKReadMenuView : UIView

@property (nonatomic, assign) BOOL isShowMenu; /**< 菜单是否显示*/


/**
 初始化菜单view
 @param frame 大小
 @param book 书籍信息
 @return 菜单
 */
- (instancetype)initWithFrame:(CGRect)frame withBook:(RKHomeListBooks *)book;

#pragma mark - 函数
/**
 显示
 @param superView 父view
 */
- (void)showToView:(UIView *)superView;

@end
