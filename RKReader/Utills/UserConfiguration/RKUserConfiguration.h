//
//  RKUserConfiguration.h
//  RKReader
//
//  Created by MBP on 2018/9/6.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RKUserConfiguration : NSObject

// 首页显示参数
@property (nonatomic, assign) CGFloat homeCoverWidth; /**< 首页封面宽度*/

// 翻页方式
@property (nonatomic, assign) UIPageViewControllerTransitionStyle transitionStyle; /**< 翻页模式*/
@property (nonatomic, assign) UIPageViewControllerNavigationOrientation navigationOrientation; /**< 上下/左右 翻页*/

// 上左下右 边距
@property (nonatomic, assign) CGFloat topPadding; /**< 上边距*/
@property (nonatomic, assign) CGFloat leftPadding; /**< 左边距*/
@property (nonatomic, assign) CGFloat bottomPadding; /**< 下边距*/
@property (nonatomic, assign) CGFloat rightPadding; /**< 右边距*/

// 底部 电池/章节/书名/页数...
@property (nonatomic, assign) CGFloat bottomStatusHeight; /**< 底部状态栏高度*/
// 阅读页大小
@property (nonatomic, assign) CGRect readViewFrame; /**< 阅读页大小*/

// 内容展示相关配置  字号/行间距/字体颜色/主题(背景图...)...
@property (nonatomic, assign) CGFloat fontSize; /**< 字号*/
@property (nonatomic, assign) CGFloat lineSpace; /**< 行间距*/
@property (nonatomic, copy) NSString *fontColor; /**< 字体颜色*/
@property (nonatomic, copy) NSString *theme; /**< 主题*/
@property (nonatomic, assign) NSInteger bgIndex; /**< 背景图索引*/

/**
 用户配置
 @return 单例
 */
+ (instancetype)sharedInstance;

/**
 保存当前用户配置
 */
- (void)saveUserConfig;

/**
 获取配置属性
 @return 属性字典
 */
- (NSDictionary *)parserAttribute;

@end
