//
//  RKReadViewSettingViewController.h
//  RKReader
//
//  Created by MBP on 2018/10/19.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKViewController.h"

@interface RKReadViewSettingViewController : RKViewController

/**
 更新UI
 @param handler 回调
 */
- (void)didNeedUpdateUI:(void(^)(void))handler;

@end
