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
