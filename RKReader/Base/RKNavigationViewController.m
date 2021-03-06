//
//  RKNavigationViewController.m
//  RKReader
//
//  Created by MBP on 2018/9/3.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKNavigationViewController.h"

@interface RKNavigationViewController () <UIGestureRecognizerDelegate>

@end

@implementation RKNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationBar.translucent = NO;
    //设置导航栏标题颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor]}];
    
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    //设置item的颜色
    self.navigationBar.tintColor = [UIColor blackColor];
    
    //手势返回
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = self;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count == 1) {
        return NO;
    }
    return YES;
}

//修复有水平方向滚动的ScrollView时边缘返回手势失效的问题
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
    if (self.childViewControllers.count > 0) { // 非根控制器
        
        // 设置返回按钮
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(THNvigationBarLeftButtonItemClick)];
        viewController.navigationItem.leftBarButtonItem.tag = 1;
    }
    
    // 这个方法才是真正执行跳转
    [super pushViewController:viewController animated:animated];
}

#pragma mark - 返回事件
// 返回
- (void)THNvigationBarLeftButtonItemClick {
    [self popViewControllerAnimated:YES];
}

- (void)dealloc {
    RKLog(@"---> %@ 销毁",[self class])
}

@end
