//
//  RKChaptersListView.h
//  RKReader
//
//  Created by MBP on 2018/10/13.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RKChaptersListView : UIView

@property (nonatomic, strong) RKBook *book; /**< 书籍*/
@property (nonatomic, assign) NSInteger currentChapter; /**< 当前章节索引*/

/**
 显示
 @param superView 父view
 @param handler 回调
 */
- (void)showInView:(UIView *)superView and:(void(^)(NSInteger selectChapter))handler;

@end
