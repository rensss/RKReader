//
//  RKReadViewController.m
//  RKReader
//
//  Created by MBP on 2018/9/6.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKReadViewController.h"
#import "RKReadView.h"

@interface RKReadViewController ()

@property (nonatomic, strong) RKReadView *readView; /**< 文字内容view*/
@property (nonatomic, strong) UIImageView *bgImageView; /**< 背景底图*/

@end

@implementation RKReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

	[self.view addSubview:self.bgImageView];
    [self.view addSubview:self.readView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
}

#pragma mark - 代理

#pragma mark - 函数
- (UIImageView *)bgImageView {
	if (!_bgImageView) {
		_bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
		_bgImageView.image = [UIImage imageWithColor:[UIColor colorWithHexString:@"bcf2cc"]];
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

@end
