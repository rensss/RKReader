//
//  RKReadMenuView.h
//  RKReader
//
//  Created by MBP on 2018/9/14.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RKReadMenuViewDelegate <NSObject>

@required

/**
 更新字体大小
 */
- (void)changeFontSize;

/**
 下一章/上一章
 @param yesOrNo yes:下一章 no:上一章
 */
- (void)forwardOrRewind:(BOOL)yesOrNo;

/**
 改变行间距
 */
- (void)changeLineSpace;

@end

@interface RKReadMenuView : UIView

@property (nonatomic, weak) id<RKReadMenuViewDelegate> delegate; /**< 代理*/

/**
 初始化菜单view
 @param frame 大小
 @param book 书籍信息
 @return 菜单
 */
- (instancetype)initWithFrame:(CGRect)frame withBook:(RKBook *)book;

#pragma mark - 函数
/**
 菜单显示
 @param superView 父view
 */
- (void)showToView:(UIView *)superView;

/**
 菜单消失的回调
 @param handler 回调
 */
- (void)dismissBlock:(void(^)(void))handler;

/**
 点击关闭按钮的回调
 @param handler 回调
 */
- (void)closeBlock:(void(^)(void))handler;

@end
