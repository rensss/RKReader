//
//  RKSetttingViewController.m
//  RKReader
//
//  Created by MBP on 2018/9/3.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKSetttingViewController.h"
#import "RKImportViewController.h"

@interface RKSetttingViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView; /**< 列表*/
@property (nonatomic, strong) NSMutableArray *dataArray; /**< 列表标题*/

@end

@implementation RKSetttingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";
    [self.view addSubview:self.tableView];
}

#pragma mark - 代理
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
	__weak typeof(self) weakSelf = self;
    // 导入
    if ([self.dataArray[indexPath.row] isEqualToString:self.dataArray[0]]) {
        RKImportViewController *importVC = [[RKImportViewController alloc] init];
        [self.navigationController pushViewController:importVC animated:YES];
    }
	// 清空所有书籍
	if ([self.dataArray[indexPath.row] isEqualToString:self.dataArray[1]]) {
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否删除全部数据"  message:@"将会清空书籍和阅读记录!"	preferredStyle:UIAlertControllerStyleAlert];
		
		// 创建并添加按钮
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[[RKFileManager sharedInstance] clearAllBooks];
			RKAlertMessage(@"删除成功", weakSelf.view);
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
		
		[alertController addAction:okAction];           // A
		[alertController addAction:cancelAction];       // B
		
		[self presentViewController:alertController animated:YES completion:nil];
	}
	
	// 清空缓存
	if ([self.dataArray[indexPath.row] isEqualToString:self.dataArray[2]]) {
		
		UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否删除全部缓存数据"  message:@"将会清空阅读记录!"	preferredStyle:UIAlertControllerStyleAlert];
		
		// 创建并添加按钮
		UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[[RKFileManager sharedInstance] clearAllUserDefaultsData];
			RKAlertMessage(@"清除成功", weakSelf.view);
		}];
		UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
		
		[alertController addAction:okAction];           // A
		[alertController addAction:cancelAction];       // B
		
		[self presentViewController:alertController animated:YES completion:nil];
	}
}

#pragma mark -- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UITableViewCell class])];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([UITableViewCell class])];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = self.dataArray[indexPath.row];
    
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
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray arrayWithObjects:@"局域网导入",@"删除全部书籍",@"清空缓存数据", nil];
    }
    return _dataArray;
}

@end
