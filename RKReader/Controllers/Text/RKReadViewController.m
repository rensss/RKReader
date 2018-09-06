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

@end

@implementation RKReadViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor colorWithRandom];
    
    [self.view addSubview:self.readView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
}

#pragma mark - 函数
- (RKReadView *)readView {
    if (!_readView) {
        RKUserConfiguration *userConfig = [RKUserConfiguration sharedInstance];
        _readView = [[RKReadView alloc] initWithFrame:CGRectMake(userConfig.leftPadding, self.statusBarHeight + userConfig.topPadding, self.view.width - userConfig.leftPadding - userConfig.rightPadding, self.view.height - self.statusBarHeight - userConfig.bottomPadding - )];
    }
    return _readView;
}

@end
