//
//  RKReadMenuView.m
//  RKReader
//
//  Created by MBP on 2018/9/14.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKReadMenuView.h"

@interface RKReadMenuView ()

@property (nonatomic, strong) UIButton *bgButton; /**< */

@property (nonatomic, strong) UIView *upBar; /**< navBar*/
@property (nonatomic, strong) UIView *bottomBar; /**< 底部view*/

@property (nonatomic, strong) UILabel *titleLabel; /**< 书名*/
@property (nonatomic, strong) UIButton *closeButton; /**< 关闭按钮*/

@property (nonatomic, strong) UIButton *reduceButton; /**< 减小字体*/
@property (nonatomic, strong) UILabel *fontSize; /**< 字号*/
@property (nonatomic, strong) UIButton *increaseButton; /**< 增大字体*/

@property (nonatomic, strong) UIButton *smallSpace; /**< 小行间距*/
@property (nonatomic, strong) UIButton *middleSpace; /**< 中行间距*/
@property (nonatomic, strong) UIButton *bigSpace; /**< 大行间距*/

@end

@implementation RKReadMenuView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgButton];
        [self addSubview:self.upBar];
        [self addSubview:self.bottomBar];
    }
    return self;
}

#pragma mark - 点击事件
/**
 消失
 */
-  (void)bgClick {
    [UIView animateWithDuration:0.25f animations:^{
        self.upBar.maxY = 0;
        self.bottomBar.y = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 函数
/**
 显示
 @param superView 父view
 */
- (void)showToView:(UIView *)superView {

    [UIView animateWithDuration:0.25f animations:^{
        self.upBar.x = 0;
        self.bottomBar.maxY = self.height - [RKUserConfiguration sharedInstance].viewControllerSafeAreaBottomHeight;
    }];
}

#pragma mark - getting
- (UIButton *)bgButton {
    if (_bgButton) {
        _bgButton = [[UIButton alloc] initWithFrame:self.bounds];
        [_bgButton addTarget:self action:@selector(bgClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}

- (UIView *)upBar {
    if (!_upBar) {
        _upBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, [RKUserConfiguration sharedInstance].viewControllerStatusBarHeight + 44)];
        _upBar.maxY = 0;
        _upBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    }
    return _upBar;
}

- (UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 80)];
        _bottomBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    }
    return _bottomBar;
}

@end
