//
//  RKAlertMessage.h
//  RKReader
//
//  Created by MBP on 2018/9/4.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import <Foundation/Foundation.h>


#import "MBProgressHUD.h"

/**
 *  自定义弹出提醒 (不带回调)
 *  @param message 提示文字
 *  @return THAlertMessage
 */
#define THAlertMessageShowInWindow(message) THAlertMessage *alertMessage = [[THAlertMessage alloc] initWithMessage:message];\
[alertMessage showInView:[[UIApplication sharedApplication].delegate window] dismiss:nil];

#define THAlertMessage(message,view) THAlertMessage *alertMessage = [[THAlertMessage alloc] initWithMessage:message];\
[alertMessage showInView:view dismiss:nil];

#define THAlertAttributeMessage(message,view) THAlertMessage *alertMessage = [[THAlertMessage alloc] initWithAttributeMessage:message];\
[alertMessage showInView:view dismiss:nil];

@interface RKAlertMessage : NSObject

// 提示信息
@property (copy,nonatomic)NSString *message;

// 富文本提示
@property (nonatomic, strong) NSAttributedString *attributeMsg;

// 初始化信息
- (instancetype)initWithMessage:(NSString *)message;

// 富文本提示
- (instancetype)initWithAttributeMessage:(NSAttributedString *)msgAttributeStr;

// 根据View显示弹窗 -- 带回调
- (void)showInView:(UIView *)view dismiss:(void(^)(void))dismiss;

@end
