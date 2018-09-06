//
//  RKUserConfiguration.h
//  RKReader
//
//  Created by MBP on 2018/9/6.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKUserConfiguration : NSObject

@property (nonatomic, assign) CGFloat homeCoverWidth; /**< 首页封面宽度*/
@property (nonatomic, assign) UIPageViewControllerTransitionStyle transitionStyle; /**< 翻页模式*/
@property (nonatomic, assign) UIPageViewControllerNavigationOrientation navigationOrientation; /**< 上下/左右 翻页*/

@property (nonatomic, assign) CGFloat topPadding; /**< 上边距*/
@property (nonatomic, assign) CGFloat leftPadding; /**< 左边距*/
@property (nonatomic, assign) CGFloat bottomPadding; /**< 下边距*/
@property (nonatomic, assign) CGFloat rightPadding; /**< 右边距*/

@property (nonatomic, assign) CGFloat bottomStatusHeight; /**< 底部状态栏高度*/

/**
 用户配置
 @return 单例
 */
+ (instancetype)sharedInstance;

/**
 保存当前用户配置
 */
- (void)saveUserConfig;

@end
