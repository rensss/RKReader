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

#pragma mark - getting
- (UIImageView *)bgImage {
    if (!_bgImage) {
        _bgImage = [[UIImageView alloc] initWithFrame:self.bounds];
    }
    return _bgImage;
}

@end


@interface RKBgImageCollectionView ()

@property (nonatomic, strong) UICollectionView *collectionView; /**< 列表*/

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

#pragma mark - getting
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumInteritemSpacing = 10;
        layout.minimumLineSpacing = 10;
        
        CGFloat width = (self.width - 10*5)/4;
        CGFloat height = kImageHeight * width / kImageWidth;
        
        layout.itemSize = CGSizeMake(width, height);
        
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        
    }
    return _collectionView;
}

@end
