//
//  RKReadViewSettingViewController.m
//  RKReader
//
//  Created by MBP on 2018/10/19.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKReadViewSettingViewController.h"
#import "RKBgImageCollectionView.h"

@interface RKReadViewSettingViewController () <UITableViewDelegate,UITableViewDataSource,RKBgImageCollectionViewDelegate>

@property (nonatomic, copy) void(^needUpdateUICallback)(void); /**< 更新UI回调*/
@property (nonatomic, strong) NSMutableArray *titleArray; /**< 标题*/
@property (nonatomic, strong) UITableView *tableView; /**< 列表*/
@property (nonatomic, strong) RKBgImageCollectionView *headerView; /**< 头视图*/

@property (nonatomic, assign) BOOL isNeedUpdateUI; /**< 是否需要更新Ui*/

@end

@implementation RKReadViewSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"设置";
    
    // 设置返回按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStylePlain target:self action:@selector(THNvigationBarLeftButtonItemClick)];
    
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

#pragma mark - 返回
- (void)THNvigationBarLeftButtonItemClick {
    
    // 调用回调
    if (self.needUpdateUICallback) {
        self.needUpdateUICallback();
    }
    // 返回
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 函数
- (void)didNeedUpdateUI:(void (^)(void))handler {
    self.needUpdateUICallback = handler;
}

#pragma mark - 代理
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
    }
    
    cell.textLabel.text = self.titleArray[indexPath.row];
    
    return cell;
}

#pragma mark -- RKBgImageCollectionViewDelegate
- (void)didSelectBgImage {
    self.isNeedUpdateUI = YES;
}

#pragma mark - getting
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.tableHeaderView = self.headerView;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (RKBgImageCollectionView *)headerView {
    if (!_headerView) {
        CGFloat height = 667 * ((self.view.width - 10*5)/4) / 375.0f;
        _headerView = [[RKBgImageCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, height + 10)];
        _headerView.delegate = self;
    }
    return _headerView;
}

- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray arrayWithObjects:@"字体", nil];
    }
    return _titleArray;
}

@end
