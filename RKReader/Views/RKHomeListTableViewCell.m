//
//  RKHomeListTableViewCell.m
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKHomeListTableViewCell.h"


@interface RKHomeListTableViewCell ()

@property (nonatomic, strong) UIView *bgView; /**< 底图*/
@property (nonatomic, strong) UIImageView *coverImage; /**< 封面*/
@property (nonatomic, strong) UILabel *nameLabel; /**< 书名*/
@property (nonatomic, strong) UILabel *progressLabel; /**< 进度*/
@property (nonatomic, strong) UILabel *sizeLabel; /**< 大小*/

@end

@implementation RKHomeListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.layer.shouldRasterize = YES;
        self.layer.rasterizationScale = [UIScreen mainScreen].scale;
        
        [self.contentView addSubview:self.bgView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(5, 5, self.width - 10, self.height - 5);
    
    self.nameLabel.frame = CGRectMake(self.coverImage.maxX + 5, 5, self.bgView.width - 10 - self.coverImage.maxX, 45);

    self.progressLabel.x = self.nameLabel.x;
    self.sizeLabel.x = self.progressLabel.x;
    self.sizeLabel.maxY = self.bgView.height - 5;
    self.progressLabel.maxY = self.sizeLabel.y - 5;
}

#pragma mark - 函数
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - setting
- (void)setBook:(RKBook *)book {
    _book = book;
    self.nameLabel.text = book.name;
    self.coverImage.image = [UIImage imageNamed:book.coverName];
    self.progressLabel.text = [NSString stringWithFormat:@"进度: %0.2f%%",book.readProgress.progress];
    self.sizeLabel.text = [NSString stringWithFormat:@"大小: %0.2f M",book.fileInfo.fileSize];
}

#pragma mark - getting
- (UIView *)bgView {
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.width - 10, self.height - 5)];
        _bgView.backgroundColor = [UIColor whiteColor];

//        _bgView.layer.cornerRadius = 5;
        _bgView.layer.borderColor = [UIColor colorWithHexString:@"333333"].CGColor;
//        _bgView.clipsToBounds = YES;

//        _bgView.layer.shadowColor = [UIColor blackColor].CGColor;//shadowColor阴影颜色
//        _bgView.layer.shadowOffset = CGSizeMake(5,5);//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
//        _bgView.layer.shadowOpacity = 0.8;//阴影透明度，默认0
//        _bgView.layer.shadowRadius = 4;//阴影半径，默认3
        
        [_bgView addSubview:self.coverImage];
        [_bgView addSubview:self.nameLabel];
        [_bgView addSubview:self.progressLabel];
        [_bgView addSubview:self.sizeLabel];
    }
    return _bgView;
}

- (UIImageView *)coverImage {
    if (!_coverImage) {
        CGFloat width = [RKUserConfiguration sharedInstance].homeCoverWidth;
        _coverImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, kCoverImageHeight*width/kCoverImageWidth)];
        
    }
    return _coverImage;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.bgView.width, 45)];
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.font = [UIFont systemFontOfSize:18];
        _nameLabel.numberOfLines = 2;
    }
    return _nameLabel;
}

- (UILabel *)progressLabel {
    if (!_progressLabel) {
        _progressLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _progressLabel.textColor = [UIColor lightGrayColor];
        _progressLabel.font = [UIFont systemFontOfSize:14];
    }
    return _progressLabel;
}

- (UILabel *)sizeLabel {
    if (!_sizeLabel) {
        _sizeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        _sizeLabel.textColor = [UIColor lightGrayColor];
        _sizeLabel.font = [UIFont systemFontOfSize:14];
    }
    return _sizeLabel;
}

@end
