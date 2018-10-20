//
//  RKBgImageCollectionView.m
//  RKReader
//
//  Created by MBP on 2018/10/19.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKBgImageCollectionView.h"

#define kImageWidth 375.0f
#define kImageHeight 667.0f

@interface RKBgImageCollectionViewCell ()

@property (nonatomic, strong) UIImageView *bgImage; /**< 背景图*/

@end

@implementation RKBgImageCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self.contentView addSubview:self.bgImage];
    }
    return self;
}

#pragma mark - 选中
- (void)setSelected:(BOOL)selected {
    if (selected) {
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 2.0f;
    }else {
        self.layer.borderWidth = 0.0f;
    }
}

#pragma mark - setting
- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    // 设置图片
    self.bgImage.image = [UIImage imageNamed:imageName];
}

#pragma mark - getting
- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _bgImage;
}

@end


@interface RKBgImageCollectionView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView; /**< 列表*/
@property (nonatomic, strong) NSMutableArray *dataArray; /**< 数据源*/

@end

@implementation RKBgImageCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.collectionView];
    }
    return self;
}

#pragma mark - 代理
#pragma mark -- UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSelectBgImage)]) {
        RKUserConfiguration *config = [RKUserConfiguration sharedInstance];
        config.bgImageName = self.dataArray[indexPath.row];
        if (indexPath.row == 2) {
            config.fontColor = @"f0f0f0";
        }else {
            config.fontColor = @"000000";
        }
        [self.delegate didSelectBgImage];
    }
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    RKBgImageCollectionViewCell *cell = (RKBgImageCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.selected) {
        [collectionView deselectItemAtIndexPath:indexPath animated:YES];
        return NO;
    }else {
        return YES;
    }
}

#pragma mark -- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RKBgImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass(RKBgImageCollectionViewCell.class) forIndexPath:indexPath];
    
    cell.imageName = self.dataArray[indexPath.item];
    if ([cell.imageName isEqualToString:[RKUserConfiguration sharedInstance].bgImageName]) {
        cell.selected = YES;
    }
    
    return cell;
}

#pragma mark - getting
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        
        CGFloat width = (self.width - 10*5)/4;
        CGFloat height = kImageHeight * width / kImageWidth;
        
        layout.itemSize = CGSizeMake(width, height);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 5, self.width, self.height - 10) collectionViewLayout:layout];
        
        _collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
        _collectionView.backgroundColor = [UIColor clearColor];
        
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        _collectionView.showsHorizontalScrollIndicator = NO;
        
        [_collectionView registerClass:[RKBgImageCollectionViewCell class] forCellWithReuseIdentifier:NSStringFromClass(RKBgImageCollectionViewCell.class)];
    }
    return _collectionView;
}

- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 10; i++) {
            NSString *name = [NSString stringWithFormat:@"reader_bg_%ld",(long)i];
            [_dataArray addObject:name];
        }
    }
    return _dataArray;
}

@end
