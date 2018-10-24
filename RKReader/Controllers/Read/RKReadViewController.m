//
//  RKReadViewController.m
//  RKReader
//
//  Created by MBP on 2018/9/6.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKReadViewController.h"
#import "RKBottomStatusBar.h"

@interface RKReadViewController ()

@property (nonatomic, strong) UIImageView *bgImageView; /**< 背景底图*/
@property (nonatomic, strong) RKBottomStatusBar *bottomBar; /**< 底部状态栏*/

@end

@implementation RKReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	[self.view addSubview:self.bgImageView];
    [self.view addSubview:self.readView];
    // 底部状态栏
    [self.view addSubview:self.bottomBar];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];

}

#pragma mark - 代理

#pragma mark - setting
- (void)setListBook:(RKHomeListBooks *)listBook {
	_listBook = listBook;
	if (_bottomBar) {
		self.bottomBar.book = listBook;
	}
}

#pragma mark - getting
- (UIImageView *)bgImageView {
	if (!_bgImageView) {
		_bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
		_bgImageView.image = [UIImage imageNamed:[RKUserConfiguration sharedInstance].bgImageName];
	}
	return _bgImageView;
}

- (RKReadView *)readView {
    if (!_readView) {
        _readView = [[RKReadView alloc] initWithFrame:[RKUserConfiguration sharedInstance].readViewFrame];
        _readView.content = self.content;
    }
    return _readView;
}

- (RKBottomStatusBar *)bottomBar {
    if (!_bottomBar) {
        _bottomBar = [[RKBottomStatusBar alloc] initWithFrame:CGRectMake(0, self.view.height - 20 - [RKUserConfiguration sharedInstance].viewControllerSafeAreaBottomHeight/2, self.view.width, 20) and:self.bookChapter];
		_bottomBar.chapters = self.chapters;
		_bottomBar.book = self.listBook;
    }
    return _bottomBar;
}
@end
