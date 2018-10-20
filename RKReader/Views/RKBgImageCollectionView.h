//
//  RKBgImageCollectionView.h
//  RKReader
//
//  Created by MBP on 2018/10/19.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RKBgImageCollectionViewDelegate <NSObject>

/**
 选中背景图
 */
- (void)didSelectBgImage;

@end

@interface RKBgImageCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *imageName; /**< 图片名*/

@end

@interface RKBgImageCollectionView : UIView

@property (nonatomic, weak) id<RKBgImageCollectionViewDelegate> delegate; /**< 代理*/

@end
