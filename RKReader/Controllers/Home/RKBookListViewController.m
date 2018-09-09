//
//  RKBookListViewController.m
//  RKReader
//
//  Created by MBP on 2018/9/3.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKBookListViewController.h"
#import "RKSetttingViewController.h"
#import "RKReadPageViewController.h"

#import "RKHomeListTableViewCell.h"// 书籍cell


@interface RKBookListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView; /**< 列表*/
@property (nonatomic, strong) NSMutableArray *dataArray; /**< 数据源*/

@end

@implementation RKBookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"首页";
    
    [self initUI];
    
    [RKFileManager sharedInstance];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	// 更新列表
	if (self.dataArray.count != [[RKFileManager sharedInstance] getBookList].count) {
		self.dataArray = nil;
		[self.tableView reloadData];
	}
}

#pragma mark - 函数
/// 布局UI
- (void)initUI {
    // 设置按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"设置"] style:UIBarButtonItemStylePlain target:self action:@selector(settingClick)];
    
    [self.view addSubview:self.tableView];
}

#pragma mark - 点击事件
- (void)settingClick {
    RKSetttingViewController *settingVC = [[RKSetttingViewController alloc] init];
    [self.navigationController pushViewController:settingVC animated:YES];
}

#pragma mark - 代理
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RKLog(@"%@",indexPath);
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
	UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)cell.accessoryView;
	[indicator startAnimating];
	
	__weak typeof(self) weakSelf = self;
	dispatch_async(dispatch_get_global_queue(0, 0), ^{
		RKReadPageViewController *readPageVC = [[RKReadPageViewController alloc] init];
		RKBook *cellBook = weakSelf.dataArray[indexPath.row];
		RKBook *book = [RKBook getLocalModelWithFileInfo:cellBook.fileInfo];
		readPageVC.book = book;
		dispatch_async(dispatch_get_main_queue(), ^{
			[indicator stopAnimating];
			RKNavigationViewController *nav = [[RKNavigationViewController alloc] initWithRootViewController:readPageVC];
			[weakSelf presentViewController:nav animated:YES completion:nil];
		});
	});
	
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RKHomeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([RKHomeListTableViewCell class])];
    
    if (!cell) {
        cell = [[RKHomeListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([RKHomeListTableViewCell class])];
		UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		cell.accessoryView = indicator;
    }
    
    RKBook *book = self.dataArray[indexPath.row];
    cell.book = book;
    
    return cell;
}

#pragma mark - getting
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
		
		if (@available(iOS 11.0, *)) {
			_tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
		}
		
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = kCoverImageHeight*[RKUserConfiguration sharedInstance].homeCoverWidth/kCoverImageWidth + 5;
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSArray *array = [[RKFileManager sharedInstance] getBookList];
        for (RKFile *file in array) {
			RKBook *book = [RKBook new];
			book.name = file.fileName;
			book.progress = 0.0f;
			book.coverName = [NSString stringWithFormat:@"cover%u",arc4random()%10+1];
			book.fileInfo = file;
            [_dataArray addObject:book];
        }
    }
    return _dataArray;
}

@end
