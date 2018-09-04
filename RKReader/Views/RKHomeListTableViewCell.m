//
//  RKHomeListTableViewCell.m
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKHomeListTableViewCell.h"

@interface RKHomeListTableViewCell ()

@property (nonatomic, strong) UIImageView *coverImage; /**< 封面*/
@property (nonatomic, strong) UILabel *nameLabel; /**< 书名*/
@property (nonatomic, strong) UILabel *progressLabel; /**< 进度*/
@property (nonatomic, strong) UILabel *sizeLabel; /**< 大小*/

@end

@implementation RKHomeListTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.coverImage];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.progressLabel];
        [self.contentView addSubview:self.sizeLabel];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
