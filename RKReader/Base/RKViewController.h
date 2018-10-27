//
//  RKViewController.h
//  RKReader
//
//  Created by MBP on 2018/9/3.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKViewController : UIViewController <UINavigationControllerDelegate>

/**
 设置是否强制转屏
 @param allowRotation 是否强制横屏 yes 横屏 no 竖屏
 */
- (void)setOrientation:(BOOL)allowRotation;

@end
