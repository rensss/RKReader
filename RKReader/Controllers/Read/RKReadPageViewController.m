//
//  RKReadPageViewController.m
//  RKReader
//
//  Created by MBP on 2018/9/6.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKReadPageViewController.h"
#import "RKReadViewController.h"
#import "RKReadMenuView.h"
#import "RKChaptersListView.h"

@interface RKReadPageViewController ()
<
UIPageViewControllerDelegate,
UIPageViewControllerDataSource,
UIGestureRecognizerDelegate,
RKReadMenuViewDelegate
>

@property (nonatomic, strong) UIPageViewController *pageViewController; /**< 显示内容的VC*/

@property (nonatomic, assign) NSInteger currentChapter; /**< 当前章节*/
@property (nonatomic, assign) NSInteger currentPage; /**< 当前页码*/

@property (nonatomic, assign) NSInteger chapterNext; /**< 上/下 一章节*/
@property (nonatomic, assign) NSInteger pageNext; /**< 上/下 一页*/

@property (nonatomic, assign) BOOL isShowMenu; /**< 是否正在显示菜单*/

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
    
    RKReadViewController *readVC = [self viewControllerChapter:self.listBook.readProgress.chapter andPage:self.listBook.readProgress.page];// 得到第一页
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
    // 隐藏导航栏
    self.navigationController.delegate = self;
    // 隐藏电池条
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:YES];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // 禁止侧滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

#pragma mark - 手势事件
- (void)showToolMenu {

	// 若已显示菜单则忽略
	if (self.isShowMenu) {
		return ;
	}
	
	self.isShowMenu = YES;
	// 菜单view
	RKReadMenuView *menu = [[RKReadMenuView alloc] initWithFrame:self.view.bounds withBook:self.book];
	menu.delegate = self;
	[menu showToView:self.view];
	
	__weak typeof(self) weakSelf = self;
	// 菜单消失
	[menu dismissBlock:^{
		weakSelf.isShowMenu = NO;
	}];
	
	// 退出阅读
	[menu closeBlock:^{
		[weakSelf dissmiss];
	}];
}

#pragma mark - 代理
#pragma mark -- UIGestureRecognizerDelegate
//解决TabView与Tap手势冲突
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
	if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
		return NO;
	}
	return  YES;
}

#pragma mark - UIPageViewControllerDataSource And UIPageViewControllerDelegate
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

#pragma mark - RKReadMenuViewDelegate
- (void)changeFontSize {
	RKLog(@"修改字号 -- %f",[RKUserConfiguration sharedInstance].fontSize);
	
	[self.book.chapters[self.currentChapter] updateFont];
	
	if (self.currentPage > self.book.chapters[self.currentChapter].pageCount - 1) {
		self.currentPage = self.book.chapters[self.currentChapter].pageCount - 1;
	}
	
	// 设置当前显示的readVC
	[self.pageViewController setViewControllers:@[[self viewControllerChapter:self.currentChapter andPage:self.currentPage]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
	
	// 更新阅读记录
	self.currentPage = 0;
	self.currentChapter = self.chapterNext;
	[self updateLocalBookData];
	
}

- (void)changeLineSpace {
	
    RKLog(@"修改行间距 -- %f",[RKUserConfiguration sharedInstance].lineSpace);
    
    [self.book.chapters[self.currentChapter] updateFont];
    
    if (self.currentPage > self.book.chapters[self.currentChapter].pageCount - 1) {
        self.currentPage = self.book.chapters[self.currentChapter].pageCount - 1;
    }
    
    // 设置当前显示的readVC
    [self.pageViewController setViewControllers:@[[self viewControllerChapter:self.currentChapter andPage:self.currentPage]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    
    // 更新阅读记录
    self.currentPage = 0;
    self.currentChapter = self.chapterNext;
    [self updateLocalBookData];
}

- (void)forwardOrRewind:(BOOL)yesOrNo {
	RKLog(@"切换章节 -- %@",yesOrNo?@"YES":@"NO");
	
	if (yesOrNo) {
		// 最后一章
		if (self.currentChapter == self.book.chapters.count - 1) {
			RKAlertMessage(@"没有下一章了~", self.view);
			return;
		}
		// 直接返回下一章
		self.pageNext = 0;
		self.chapterNext = self.currentChapter + 1;
		
	}else {
		// 第一章的最后一页
		if (self.currentChapter == 0) {
			RKAlertMessage(@"没有上一章了~", self.view);
			return;
		}
		self.pageNext = 0;
		self.chapterNext = self.currentChapter - 1;
	}
	// 设置当前显示的readVC
	[self.pageViewController setViewControllers:@[[self viewControllerChapter:self.chapterNext andPage:self.pageNext]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
	
	// 更新阅读记录
	self.currentPage = 0;
	self.currentChapter = self.chapterNext;
	[self updateLocalBookData];
}

/**
 弹出章节列表
 */
- (void)showChaptersList {
	
	RKChaptersListView *listView = [[RKChaptersListView alloc] initWithFrame:self.view.bounds];
	listView.currentChapter = self.currentChapter;
	listView.book = self.book;
	
	[listView showInView:self.view and:^(NSInteger selectChapter) {
		// 跳转
		self.pageNext = 0;
		self.chapterNext = selectChapter;
		
		// 设置当前显示的readVC
		[self.pageViewController setViewControllers:@[[self viewControllerChapter:self.chapterNext andPage:self.pageNext]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
		
		// 更新阅读记录
		self.currentPage = 0;
		self.currentChapter = self.chapterNext;
		[self updateLocalBookData];
	}];
	
}

#pragma mark - 函数
#pragma mark -- 根据index得到对应的UIViewController
- (RKReadViewController *)viewControllerChapter:(NSInteger)chapter andPage:(NSInteger)page {
	
    // 创建一个新的控制器类，并且分配给相应的数据
    RKReadViewController *readVC = [[RKReadViewController alloc] init];
	readVC.content = [self.book.chapters[chapter] stringOfPage:page];
	readVC.chapter = chapter;
	readVC.page = page;
	readVC.bookChapter = self.book.chapters[chapter];
	readVC.chapters = self.book.chapters.count;
	readVC.listBook = self.listBook;

    return readVC;
}

#pragma mark -- 保存阅读进度
/// 保存阅读进度
- (void)updateLocalBookData {
	
	self.listBook.readProgress.chapter = self.currentChapter;
	self.listBook.readProgress.page = self.currentPage;
	self.listBook.readProgress.progress = self.currentChapter*1.0f/self.book.chapters.count;
	self.listBook.readProgress.title = self.book.chapters[self.currentChapter].title;
	
	RKReadViewController *readVC = (RKReadViewController *)self.pageViewController.viewControllers.firstObject;
	readVC.listBook = self.listBook;
	
	[RKFileManager updateHomeListDataWithListBook:self.listBook];
}

#pragma mark -- 退出阅读
/// 关闭页面
- (void)dissmiss {
    // 侧滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    // 显示电池条
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:YES];
    // 关闭
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - setting
- (void)setBook:(RKBook *)book {
	_book = book;
	
	self.currentChapter = self.listBook.readProgress.chapter;
	self.currentPage = self.listBook.readProgress.page;
}

@end
