//
//  RKReadMenuView.m
//  RKReader
//
//  Created by MBP on 2018/9/14.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKReadMenuView.h"

#define kNavBarHight 44

@interface RKReadMenuView ()

@property (nonatomic, strong) RKBook *book; /**< 当前书籍对象*/

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

@property (nonatomic, strong) void(^closeBlock)(void); /**< 消失回调*/

@end

@implementation RKReadMenuView

/**
 初始化菜单view
 @param frame 大小
 @param book 书籍信息
 @return 菜单
 */
- (instancetype)initWithFrame:(CGRect)frame withBook:(RKBook *)book {
	self = [super initWithFrame:frame];
	if (self) {
		_book = book;
		[self addSubview:self.bgButton];
		[self addSubview:self.upBar];
		[self addSubview:self.bottomBar];
	}
	return self;
}

#pragma mark - 点击事件
/// 消失
-  (void)bgClick {
    [UIView animateWithDuration:0.25f animations:^{
        self.upBar.maxY = 0;
        self.bottomBar.y = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/// 点击关闭按钮
- (void)closeButtonClick {
	if (self.closeBlock) {
		self.closeBlock();
	}
}

#pragma mark - 函数
/**
 显示
 @param superView 父view
 */
- (void)showToView:(UIView *)superView {
	[superView addSubview:self];
	
    [UIView animateWithDuration:0.25f animations:^{
        self.upBar.y = 0;
        self.bottomBar.maxY = self.height;
    }];
}

/**
 消失的回调
 @param handler 回调
 */
- (void)dismissBlock:(void(^)(void))handler {
	self.closeBlock = handler;
}

#pragma mark - getting
- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] initWithFrame:self.bounds];
        [_bgButton addTarget:self action:@selector(bgClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}

- (UIView *)upBar {
    if (!_upBar) {
        _upBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, [RKUserConfiguration sharedInstance].viewControllerStatusBarHeight + kNavBarHight)];
        _upBar.maxY = 0;
        _upBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
		
		[_upBar addSubview:self.closeButton];
    }
    return _upBar;
}

- (UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 80 + [RKUserConfiguration sharedInstance].viewControllerSafeAreaBottomHeight)];
        _bottomBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
    }
    return _bottomBar;
}

- (UIButton *)closeButton {
	if (!_closeButton) {
		_closeButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 18, 18)];
		_closeButton.centerY = [RKUserConfiguration sharedInstance].viewControllerStatusBarHeight + kNavBarHight/2;
		[_closeButton setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
		
		[_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
	}
	return _closeButton;
}

@end
