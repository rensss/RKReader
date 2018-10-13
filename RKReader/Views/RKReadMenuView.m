//
//  RKReadMenuView.m
//  RKReader
//
//  Created by MBP on 2018/9/14.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKReadMenuView.h"

#define kNavBarHight 44.0f
#define kButtonTag 2000
#define kSpaceWidth 102.0f
#define kSpacePadding (self.width-kSpaceWidth*3)/4

@interface RKReadMenuView ()

@property (nonatomic, strong) RKBook *book; /**< 当前书籍对象*/

@property (nonatomic, strong) UIButton *bgButton; /**< */

@property (nonatomic, strong) UIView *upBar; /**< navBar*/
@property (nonatomic, strong) UIView *bottomBar; /**< 底部view*/

@property (nonatomic, strong) UILabel *titleLabel; /**< 书名*/
@property (nonatomic, strong) UIButton *closeButton; /**< 关闭按钮*/

@property (nonatomic, strong) UIButton *rewind; /**< 上一章*/
@property (nonatomic, strong) UIButton *forword; /**< 下一章*/
@property (nonatomic, strong) UIButton *reduceButton; /**< 减小字体*/
@property (nonatomic, strong) UILabel *fontSize; /**< 字号*/
@property (nonatomic, strong) UIButton *increaseButton; /**< 增大字体*/

@property (nonatomic, strong) UIButton *bigSpace; /**< 大行间距*/
@property (nonatomic, strong) UIButton *middleSpace; /**< 中行间距*/
@property (nonatomic, strong) UIButton *smallSpace; /**< 小行间距*/

@property (nonatomic, strong) void(^dismissBlock)(void); /**< 消失回调*/
@property (nonatomic, strong) void(^closeBlock)(void); /**< 点击关闭按钮回调*/

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
	// 显示电池条
	[[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
    [UIView animateWithDuration:0.25f animations:^{
        self.upBar.maxY = 0;
        self.bottomBar.y = self.height;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
		if (self.dismissBlock) {
			self.dismissBlock();
		}
    }];
}

/// 点击关闭按钮
- (void)closeButtonClick {
	if (self.closeBlock) {
		self.closeBlock();
	}
}

- (void)buttonClick:(UIButton *)button {
	switch (button.tag - kButtonTag) {
		case 0:// 上一章
		{
			if (self.delegate && [self.delegate respondsToSelector:@selector(forwardOrRewind:)]) {
				[self.delegate forwardOrRewind:NO];
			}
		}
			break;
		case 1:// 下一章
		{
			if (self.delegate && [self.delegate respondsToSelector:@selector(forwardOrRewind:)]) {
				[self.delegate forwardOrRewind:YES];
			}
		}
			break;
		case 2:// 减小字体
		{
			if ([RKUserConfiguration sharedInstance].fontSize < 14) {
				RKAlertMessageShowInWindow(@"不能再小了!");
			}
			[RKUserConfiguration sharedInstance].fontSize -= 1.0f;
			self.fontSize.text = [NSString stringWithFormat:@"%.0f",[RKUserConfiguration sharedInstance].fontSize];
			[[RKUserConfiguration sharedInstance] saveUserConfig];
			if (self.delegate && [self.delegate respondsToSelector:@selector(changeFontSize)]) {
				[self.delegate changeFontSize];
			}
		}
			break;
		case 3:// 增大字体
		{
			if ([RKUserConfiguration sharedInstance].fontSize > 22) {
				RKAlertMessageShowInWindow(@"不能再大了!");
			}
			[RKUserConfiguration sharedInstance].fontSize += 1.0f;
			self.fontSize.text = [NSString stringWithFormat:@"%.0f",[RKUserConfiguration sharedInstance].fontSize];
			[[RKUserConfiguration sharedInstance] saveUserConfig];
			if (self.delegate && [self.delegate respondsToSelector:@selector(changeFontSize)]) {
				[self.delegate changeFontSize];
			}
		}
			break;
		case 4:// 大行间距
		{
			[RKUserConfiguration sharedInstance].lineSpace = 16.0f;
			[self changeLineSpace];
		}
			break;
		case 5:// 中行间距
		{
			[RKUserConfiguration sharedInstance].lineSpace = 8.0f;
			[self changeLineSpace];
		}
			break;
		case 6:// 小行间距
		{
			[RKUserConfiguration sharedInstance].lineSpace = 4.0f;
			[self changeLineSpace];
		}
			break;
			
		default:
			break;
	}
}

#pragma mark - 函数
/**
 显示
 @param superView 父view
 */
- (void)showToView:(UIView *)superView {
	
	// 显示电池条
	[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
	
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
	self.dismissBlock = handler;
}

/**
 点击关闭按钮的回调
 @param handler 回调
 */
- (void)closeBlock:(void(^)(void))handler {
	self.closeBlock = handler;
}

#pragma mark -- 私有函数
/// 修改行间距(1.保存用户配置2.修改页面)
- (void)changeLineSpace {
	[[RKUserConfiguration sharedInstance] saveUserConfig];
	if (self.delegate && [self.delegate respondsToSelector:@selector(changeLineSpace)]) {
		[self.delegate changeLineSpace];
	}
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
        _upBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];
		
		[_upBar addSubview:self.closeButton];
		[_upBar addSubview:self.titleLabel];
    }
    return _upBar;
}

- (UIView *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, 120 + [RKUserConfiguration sharedInstance].viewControllerSafeAreaBottomHeight)];
        _bottomBar.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8f];
		
		[_bottomBar addSubview:self.rewind];
		[_bottomBar addSubview:self.forword];
		[_bottomBar addSubview:self.fontSize];
		[_bottomBar addSubview:self.reduceButton];
		[_bottomBar addSubview:self.increaseButton];
		
		[_bottomBar addSubview:self.bigSpace];
		[_bottomBar addSubview:self.middleSpace];
		[_bottomBar addSubview:self.smallSpace];
    }
    return _bottomBar;
}

- (UIButton *)closeButton {
	if (!_closeButton) {
		_closeButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 0, 18, 18)];
		_closeButton.centerY = [RKUserConfiguration sharedInstance].viewControllerStatusBarHeight + kNavBarHight/2;
		[_closeButton setImage:[UIImage imageNamed:@"关闭白"] forState:UIControlStateNormal];
		
		[_closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
	}
	return _closeButton;
}

- (UILabel *)titleLabel {
	if (!_titleLabel) {
		_titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 20)];
		_titleLabel.centerX = self.width/2;
		_titleLabel.centerY = self.closeButton.centerY;
		_titleLabel.textColor = [UIColor whiteColor];
		_titleLabel.font = [UIFont systemFontOfSize:20];
		_titleLabel.text = self.book.name;
		_titleLabel.textAlignment = NSTextAlignmentCenter;
	}
	return _titleLabel;
}

- (UIButton *)rewind {
	if (!_rewind) {
		_rewind = [[UIButton alloc] initWithFrame:CGRectMake(5, 8, 22, 22)];
		_rewind.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
		_rewind.tintColor = [UIColor whiteColor];
		[_rewind setBackgroundImage:[[UIImage imageNamed:@"返回"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
		_rewind.tag = kButtonTag;
		[_rewind addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _rewind;
}

- (UIButton *)forword {
	if (!_forword) {
		_forword = [[UIButton alloc] initWithFrame:self.rewind.frame];
		_forword.hitTestEdgeInsets = UIEdgeInsetsMake(-10, -10, -10, -10);
		_forword.maxX = self.width - 5;
		_forword.tintColor = [UIColor whiteColor];
		[_forword setBackgroundImage:[[UIImage imageNamed:@"下一章"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
		_forword.tag = kButtonTag + 1;
		[_forword addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _forword;
}

- (UILabel *)fontSize {
	if (!_fontSize) {
		_fontSize = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
		_fontSize.center = CGPointMake(self.width/2, self.rewind.centerY);
		_fontSize.textColor = [UIColor whiteColor];
		_fontSize.font = [UIFont systemFontOfSize:18];
		_fontSize.textAlignment = NSTextAlignmentCenter;
		_fontSize.text = [NSString stringWithFormat:@"%.0f",[RKUserConfiguration sharedInstance].fontSize];
	}
	return _fontSize;
}

- (UIButton *)reduceButton {
	if (!_reduceButton) {
		_reduceButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 28, 28)];
		_reduceButton.maxX = self.fontSize.x - 20;
		_reduceButton.centerY = self.fontSize.centerY;
		
		_reduceButton.tag = kButtonTag + 2;
		[_reduceButton setBackgroundImage:[UIImage imageNamed:@"字体减小"] forState:UIControlStateNormal];
		[_reduceButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _reduceButton;
}

- (UIButton *)increaseButton {
	if (!_increaseButton) {
		_increaseButton = [[UIButton alloc] initWithFrame:self.reduceButton.frame];
		_increaseButton.x = self.fontSize.maxX + 20;

		_increaseButton.tag = kButtonTag + 3;
		[_increaseButton setBackgroundImage:[UIImage imageNamed:@"字体增大"] forState:UIControlStateNormal];
		[_increaseButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _increaseButton;
}

- (UIButton *)bigSpace {
	if (!_bigSpace) {
		_bigSpace = [[UIButton alloc] initWithFrame:CGRectMake(kSpacePadding, self.fontSize.maxY + 20, kSpaceWidth, 32)];
		
		_bigSpace.tag = kButtonTag + 4;
		_bigSpace.tintColor = [UIColor whiteColor];
		[_bigSpace setImage:[[UIImage imageNamed:@"lineSpace_big"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
		[_bigSpace addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _bigSpace;
}

- (UIButton *)middleSpace {
	if (!_middleSpace) {
		_middleSpace = [[UIButton alloc] initWithFrame:self.bigSpace.frame];
		_middleSpace.x = self.bigSpace.maxX + kSpacePadding;
		
		_middleSpace.tag = kButtonTag + 5;
		_middleSpace.tintColor = [UIColor whiteColor];
		[_middleSpace setImage:[[UIImage imageNamed:@"lineSpace_mid"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
		[_middleSpace addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _middleSpace;
}

- (UIButton *)smallSpace {
	if (!_smallSpace) {
		_smallSpace = [[UIButton alloc] initWithFrame:self.middleSpace.frame];
		_smallSpace.x = self.middleSpace.maxX + kSpacePadding;
		
		_smallSpace.tag = kButtonTag + 6;
		_smallSpace.tintColor = [UIColor whiteColor];
		[_smallSpace setImage:[[UIImage imageNamed:@"lineSpace_small"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate] forState:UIControlStateNormal];
		[_smallSpace addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
	}
	return _smallSpace;
}

@end
