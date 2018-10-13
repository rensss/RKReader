//
//  RKChaptersLstView.m
//  RKReader
//
//  Created by MBP on 2018/10/13.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKChaptersLstView.h"

@interface RKChaptersLstView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton *bgButton; /**< 背景按钮*/
@property (nonatomic, strong) NSMutableArray *dataArray; /**< 数据源*/
@property (nonatomic, strong) UITableView *tableView; /**< 列表*/
@property (nonatomic, copy) void(^callBack)(NSInteger selectChapter); /**< 回调*/

@end

@implementation RKChaptersLstView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.bgButton];
        [self addSubview:self.tableView];
    }
    return self;
}

#pragma mark - 函数
- (void)showInView:(UIView *)superView and:(void (^)(NSInteger))handler {
    self.callBack = handler;
    self.maxX = 0;
    [superView addSubview:self];
    [UIView animateWithDuration:0.25f animations:^{
        self.x = 0;
    }];
}

- (void)dismiss {
    [UIView animateWithDuration:0.25f animations:^{
        self.maxX = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

#pragma mark - 点击事件
- (void)bgClick {
    [self dismiss];
}

#pragma mark - 代理
#pragma mark -- UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.callBack) {
        self.callBack(indexPath.row);
        [self dismiss];
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
    }
    
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

#pragma mark - setting
- (void)setBook:(RKBook *)book {
    _book = book;
    
    __weak typeof(self) weakSelf = self;
    [book.chapters enumerateObjectsUsingBlock:^(RKBookChapter * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.dataArray addObject:[obj.title stringByTrimmingWhitespaceAndAllNewLine]];
    }];
    [self.tableView reloadData];
}

#pragma mark - getting
- (UIButton *)bgButton {
    if (!_bgButton) {
        _bgButton = [[UIButton alloc] initWithFrame:self.bounds];
        
        [_bgButton addTarget:self action:@selector(bgClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _bgButton;
}


- (UITableView *)tableView {
    if (!_tableView) {
        
        RKUserConfiguration *config = [RKUserConfiguration sharedInstance];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, config.viewControllerStatusBarHeight + 44, self.width*4/5, self.height - config.viewControllerStatusBarHeight - config.viewControllerSafeAreaBottomHeight - config.readMenuHeight) style:UITableViewStylePlain];
        
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 50;
        
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

@end
