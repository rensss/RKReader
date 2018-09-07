//
//  RKReadPageViewController.m
//  RKReader
//
//  Created by MBP on 2018/9/6.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKReadPageViewController.h"
#import "RKReadViewController.h"

@interface RKReadPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@property (nonatomic, strong) UIPageViewController *pageViewController; /**< 显示内容的VC*/

@property (nonatomic, assign) NSInteger currentPage; /**< 当前页码*/


@end

@implementation RKReadPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(20)};
    //    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
    
    // 根据给定的属性实例化UIPageViewController
    _pageViewController = [[UIPageViewController alloc]
                           initWithTransitionStyle:[RKUserConfiguration sharedInstance].transitionStyle navigationOrientation:[RKUserConfiguration sharedInstance].navigationOrientation
                           options:options];
    
    // 设置UIPageViewController代理和数据源
    _pageViewController.delegate = self;
    _pageViewController.dataSource = self;
    
    // 让UIPageViewController对象，显示相应的页数据。
    // UIPageViewController对象要显示的页数据封装成为一个NSArray。
    // 因为我们定义UIPageViewController对象显示样式为显示一页（options参数指定）。
    // 如果要显示2页，NSArray中，应该有2个相应页数据。
    
    // 设置UIPageViewController初始化数据, 将数据放在NSArray里面
    // 如果 options 设置了 UIPageViewControllerSpineLocationMid,注意viewControllers至少包含两个数据,且 doubleSided = YES
    
    RKReadViewController *readVC = [self viewControllerAtIndex:self.selectIndex];// 得到第一页
    NSArray *viewControllers = [NSArray arrayWithObject:readVC];

    [_pageViewController setViewControllers:viewControllers
                                  direction:UIPageViewControllerNavigationDirectionReverse
                                   animated:NO
                                 completion:nil];
    
    // 设置UIPageViewController 尺寸
    _pageViewController.view.frame = self.view.bounds;
    
    // 在页面上，显示UIPageViewController对象的View
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 禁止侧滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)dealloc {
    // 侧滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate
#pragma mark -- 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {

//    NSUInteger index = ((RKReadViewController *)viewController).currentIndex;
//
//    if ((index == 0) || (index == NSNotFound)) {
//        return nil;
//    }
//    index--;
    /*返回的ViewController，将被添加到相应的UIPageViewController对象上。
     UIPageViewController对象会根据UIPageViewControllerDataSource协议方法,自动来维护次序
     不用我们去操心每个ViewController的顺序问题*/
    self.currentPage --;
    return [self viewControllerAtIndex:self.currentPage];
}

#pragma mark -- 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {

//    NSUInteger index = ((RKReadViewController *)viewController).currentIndex;
//    if (index == NSNotFound) {
//        return nil;
//    }
//    index++;
//    if (index == [self.dataArray count]) {
//        return nil;
//    }
    
    self.currentPage ++;
    return [self viewControllerAtIndex:self.currentPage];
}

// 页面跳转回调
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    RKLog(@"didFinishAnimating -- %@ -- completed:%@",finished?@YES:@NO,completed?@YES:@NO);
    
    if (completed) {
        
    } else {
        
    }
}

// 页面将要跳转
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    RKLog(@"willTransitionToViewControllers");
}

#pragma mark - 根据index得到对应的UIViewController
- (RKReadViewController *)viewControllerAtIndex:(NSInteger)index {
//    if (([self.dataArray count] == 0) || (index >= [self.dataArray count])) {
//        return nil;
//    }
    if (index < 0) {
        return nil;
    }
    // 创建一个新的控制器类，并且分配给相应的数据
    RKReadViewController *readVC = [[RKReadViewController alloc] init];
    readVC.content = [NSString stringWithFormat:@"index_%ld",index];
//    contentVC.shortVideo = self.dataArray[index];
//    contentVC.currentIndex = index;

//    if (index == self.dataArray.count - 1) {
//
//    }

    return readVC;
}


@end
