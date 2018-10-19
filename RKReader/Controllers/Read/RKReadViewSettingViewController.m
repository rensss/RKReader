//
//  RKReadViewSettingViewController.m
//  RKReader
//
//  Created by MBP on 2018/10/19.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKReadViewSettingViewController.h"

@interface RKReadViewSettingViewController ()

@property (nonatomic, copy) void(^needUpdateUICallback)(void); /**< 更新UI回调*/

@end

@implementation RKReadViewSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark - 函数
- (void)didNeedUpdateUI:(void (^)(void))handler {
    self.needUpdateUICallback = handler;
}

#pragma mark - getting


@end
