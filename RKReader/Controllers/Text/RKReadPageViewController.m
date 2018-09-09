//
//  RKReadPageViewController.m
//  RKReader
//
//  Created by MBP on 2018/9/6.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKReadPageViewController.h"
#import "RKReadViewController.h"

@interface RKReadPageViewController () <UIPageViewControllerDelegate, UIPageViewControllerDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController; /**< 显示内容的VC*/

@property (nonatomic, assign) NSInteger currentChapter; /**< 当前章节*/
@property (nonatomic, assign) NSInteger currentPage; /**< 当前页码*/

@property (nonatomic, assign) NSInteger chapterNext; /**< 上/下 一章节*/
@property (nonatomic, assign) NSInteger pageNext; /**< 上/下 一页*/

@end

@implementation RKReadPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// 添加点击手势
	[self.view addGestureRecognizer:({
		UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showToolMenu)];
		tap.delegate = self;
		tap;
	})];
	
    // 设置UIPageViewController的配置项
    NSDictionary *options = @{UIPageViewControllerOptionInterPageSpacingKey : @(20)};
//        NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey : @(UIPageViewControllerSpineLocationMin)};
	
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
    
    RKReadViewController *readVC = [self viewControllerChapter:self.book.readProgress.chapter andPage:self.book.readProgress.page];// 得到第一页
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

- (void)setBook:(RKBook *)book {
	_book = book;
	
	self.currentChapter = self.book.readProgress.chapter;
	self.currentPage = self.book.readProgress.page;
}

#pragma mark - 代理
#pragma mark -- UIGestureRecognizerDelegate
#pragma mark -  UIGestureRecognizer Delegate
//解决TabView与Tap手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//	if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
//		return NO;
//	}
	return  YES;
}

#pragma mark -- UIPageViewControllerDataSource And UIPageViewControllerDelegate
#pragma mark -- 返回上一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
	
	self.pageNext = self.currentPage;
	self.chapterNext = self.currentChapter;
	
	if (self.pageNext==0 && self.chapterNext == 0) {
		return nil;
	}
	if (self.pageNext == 0) {
		self.chapterNext--;
		self.pageNext = self.book.chapters[self.chapterNext].pageCount - 1;
	}else {
		self.pageNext--;
	}
	
	RKLog(@"chapter:%ld -- page:%ld",self.chapterNext,self.pageNext);
    return [self viewControllerChapter:self.chapterNext andPage:self.pageNext];
}

#pragma mark -- 返回下一个ViewController对象
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
	
	self.pageNext = self.currentPage;
	self.chapterNext = self.currentChapter;
	if (self.pageNext == self.book.chapters.lastObject.pageCount - 1 && self.chapterNext == self.book.chapters.count - 1) {
		return nil;
	}
	if (self.pageNext == self.book.chapters[self.chapterNext].pageCount - 1) {
		self.chapterNext ++;
		self.pageNext = 0;
	}else {
		self.pageNext ++;
	}
	RKLog(@"chapter:%ld -- page:%ld",self.chapterNext,self.pageNext);
	return [self viewControllerChapter:self.chapterNext andPage:self.pageNext];
}

// 页面跳转回调
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed {
    RKLog(@"didFinishAnimating -- %@ -- completed:%@",finished?@YES:@NO,completed?@YES:@NO);
    
    if (completed) {
		self.currentChapter = self.chapterNext;
		self.currentPage = self.pageNext;
		[self updateLocalBookData];
    } else {
//		RKReadViewController *readViewVC = (RKReadViewController *)previousViewControllers.firstObject;
//		RKLog(@"%ld -- %ld -|- %ld -- %ld",self.currentChapter,self.currentPage,readViewVC.chapter,readViewVC.page);
//		self.currentPage = readViewVC.page;
//		self.currentChapter = readViewVC.chapter;
    }
}

// 页面将要跳转
- (void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers {
    RKLog(@"willTransitionToViewControllers");
//	self.currentChapter = self.chapterNext;
//	self.currentPage = self.pageNext;
	RKLog(@"%ld -|- %ld",self.currentChapter,self.currentPage);
}

#pragma mark - 函数
#pragma mark -- 根据index得到对应的UIViewController
- (RKReadViewController *)viewControllerChapter:(NSInteger)chapter andPage:(NSInteger)page {
	
    // 创建一个新的控制器类，并且分配给相应的数据
    RKReadViewController *readVC = [[RKReadViewController alloc] init];
	readVC.content = [self.book.chapters[chapter] stringOfPage:page];
	readVC.chapter = self.currentPage;
	readVC.page = self.currentPage;
	
    return readVC;
}

- (void)updateLocalBookData {
	
	self.book.readProgress.chapter = self.currentChapter;
	self.book.readProgress.page = self.currentPage;
	self.book.readProgress.progress = self.currentChapter*1.0f/self.book.chapters.count;
	self.book.readProgress.title = self.book.chapters[self.currentChapter].title;
	[RKBook archiverBookData:self.book];
}

#pragma mark - 手势事件
- (void)showToolMenu {
	RKLog(@"点击屏幕");
	
//	[self.navigationController popViewControllerAnimated:YES];
	[self dismissViewControllerAnimated:YES completion:nil];
}


@end
