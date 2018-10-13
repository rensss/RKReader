//
//  RKChaptersLstView.h
//  RKReader
//
//  Created by MBP on 2018/10/13.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKChaptersLstView : UIView

@property (nonatomic, strong) RKBook *book; /**< 书籍*/


/**
 显示
 @param superView 父view
 @param handler 回调
 */
- (void)showInView:(UIView *)superView and:(void(^)(NSInteger selectChapter))handler;

@end
