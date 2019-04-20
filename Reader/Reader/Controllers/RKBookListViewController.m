//
//  RKBookListViewController.m
//  Reader
//
//  Created by RZK on 2019/4/20.
//  Copyright © 2019 RZK. All rights reserved.
//

#import "RKBookListViewController.h"

@interface RKBookListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView; /**< 列表*/
@property (nonatomic, strong) NSMutableArray *dataArray; /**< 数据源*/
	
@end

@implementation RKBookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navigationItem.title = @"Reader";
	
	[self initUI];
}

#pragma mark - 函数
/// 布局UI
- (void)initUI {
	// 设置按钮
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"设置"] style:UIBarButtonItemStylePlain target:self action:@selector(settingClick)];
	
	UITableView *tableView = [UITableView new];
	self.tableView = tableView;
	[self.view addSubview:self.tableView];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.rowHeight = 100;
	tableView.tableFooterView = [UIView new];

	
//	// 赋值底部安全区域高度
//	[RKUserConfiguration sharedInstance].viewControllerSafeAreaBottomHeight = self.safeAreaInsets.bottom;
}

- (void)settingClick {
	
}
	
#pragma mark - delegate
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.dataArray.count;
}
	
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellIdentifier = @"cellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
	
	if (!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
	}
	
	return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	
}

@end
