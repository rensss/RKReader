//
//  RKReadMenuView.h
//  RKReader
//
//  Created by MBP on 2018/9/14.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKReadMenuView : UIView

@property (nonatomic, assign) BOOL isShowMenu; /**< 菜单是否显示*/

#pragma mark - 函数
/**
 显示
 @param isShow 是否显示
 */
- (void)showAnimation:(BOOL)isShow;

@end
