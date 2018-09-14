//
//  RKUserConfiguration.m
//  RKReader
//
//  Created by MBP on 2018/9/6.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKUserConfiguration.h"

@implementation RKUserConfiguration

+ (instancetype)sharedInstance
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:kUserConfigutationPATH];
        NSMutableDictionary *dict = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        // 首页
        if ([[dict allKeys] containsObject:kUserConfigHomeCoverWidth]) {
            self.homeCoverWidth = [dict[kUserConfigHomeCoverWidth] floatValue];
        } else {
            self.homeCoverWidth = 80.0f;
        }
		// 翻页
        if ([[dict allKeys] containsObject:kUserConfigTransitionStyle]) {
            self.transitionStyle = [dict[kUserConfigTransitionStyle] integerValue];
        }else {
            self.transitionStyle = UIPageViewControllerTransitionStylePageCurl;
        }
        if ([[dict allKeys] containsObject:kUserConfigNavigationOrientation]) {
            self.navigationOrientation = [dict[kUserConfigNavigationOrientation] integerValue];
        }else {
            self.navigationOrientation = UIPageViewControllerNavigationOrientationHorizontal;
        }
		// 底部状态栏
        if ([[dict allKeys] containsObject:kUserConfigBottomStatusHeight]) {
            self.bottomStatusHeight = [dict[kUserConfigBottomStatusHeight] floatValue];
        }else {
            self.bottomStatusHeight = 20.0f;
        }
		// 上左下右
        if ([[dict allKeys] containsObject:kUserConfigTopPadding]) {
            self.topPadding = [dict[kUserConfigTopPadding] floatValue];
        }else {
            self.topPadding = 10.0f;
        }
        if ([[dict allKeys] containsObject:kUserConfigLeftPadding]) {
            self.leftPadding = [dict[kUserConfigLeftPadding] floatValue];
        }else {
            self.leftPadding = 10.0f;
        }
        if ([[dict allKeys] containsObject:kUserConfigBottomPadding]) {
            self.bottomPadding = [dict[kUserConfigBottomPadding] floatValue];
        }else {
            self.bottomPadding = 10.0f;
        }
        if ([[dict allKeys] containsObject:kUserConfigRightPadding]) {
            self.rightPadding = [dict[kUserConfigRightPadding] floatValue];
        }else {
            self.rightPadding = 10.0f;
        }
		// 显示相关数据
		if ([[dict allKeys] containsObject:kUserConfigFontSize]) {
			self.fontSize = [dict[kUserConfigFontSize] floatValue];
		}else {
			self.fontSize = 18.0f;
		}
		if ([[dict allKeys] containsObject:kUserConfigLineSpace]) {
			self.lineSpace = [dict[kUserConfigLineSpace] floatValue];
		}else {
			self.lineSpace = 8.0f;
		}
		if ([[dict allKeys] containsObject:kUserConfigFontColor]) {
			self.fontColor = dict[kUserConfigFontColor];
		}else {
			self.fontColor = @"000000";
		}
		if ([[dict allKeys] containsObject:kUserConfigTheme]) {
			self.theme = dict[kUserConfigTheme];
		}else {
			self.theme = @"Normal";
		}
		if ([[dict allKeys] containsObject:kUserConfigBgIndex]) {
			self.bgIndex = [dict[kUserConfigBgIndex] integerValue];
		}else {
			self.bgIndex = 0;
		}
		// 阅读页大小
		if ([[dict allKeys] containsObject:kUserConfigReadViewFrame]) {
			self.readViewFrame = [dict[kUserConfigReadViewFrame] CGRectValue];
		}else {
			CGRect frame = CGRectMake(self.leftPadding, kStatusHight + self.topPadding, kScreenWidth - self.leftPadding - self.rightPadding, kScreenHeight - kStatusHight - self.bottomPadding - self.bottomStatusHeight - kSafeAreaBottom);
			self.readViewFrame = frame;
		}
        // 保存默认值
        [self saveUserConfig];
    }
    return self;
}

#pragma mark - setting
- (void)setViewControllerStatusBarHeight:(CGFloat)viewControllerStatusBarHeight {
    _viewControllerStatusBarHeight = viewControllerStatusBarHeight;
}

- (void)setViewControllerSafeAreaBottomHeight:(CGFloat)viewControllerSafeAreaBottomHeight {
    _viewControllerSafeAreaBottomHeight = viewControllerSafeAreaBottomHeight;
    self.viewControllerStatusBarHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
}

#pragma mark - 函数
/**
 * 保存当前用户配置
 */
- (void)saveUserConfig {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setValue:@(self.homeCoverWidth) forKey:kUserConfigHomeCoverWidth];
    [dict setValue:@(self.transitionStyle) forKey:kUserConfigTransitionStyle];
    [dict setValue:@(self.navigationOrientation) forKey:kUserConfigNavigationOrientation];
	[dict setValue:@(self.bottomStatusHeight) forKey:kUserConfigBottomStatusHeight];
	[dict setValue:@(self.topPadding) forKey:kUserConfigTopPadding];
	[dict setValue:@(self.leftPadding) forKey:kUserConfigLeftPadding];
	[dict setValue:@(self.bottomPadding) forKey:kUserConfigBottomPadding];
	[dict setValue:@(self.readViewFrame) forKey:kUserConfigReadViewFrame];
	[dict setValue:@(self.rightPadding) forKey:kUserConfigRightPadding];
	[dict setValue:@(self.fontSize) forKey:kUserConfigFontSize];
	[dict setValue:@(self.lineSpace) forKey:kUserConfigLineSpace];
	[dict setValue:self.fontColor forKey:kUserConfigFontColor];
	[dict setValue:self.theme forKey:kUserConfigTheme];
	[dict setValue:@(self.bgIndex) forKey:kUserConfigBgIndex];
	
    // 删除旧版本
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:kUserConfigutationPATH error:&error];
    if (error) {
        RKLog(@"删除用户配置失败 -- %@",error);
    }
    // 保存新版本
    [NSKeyedArchiver archiveRootObject:dict toFile:kUserConfigutationPATH];
}

- (NSDictionary *)parserAttribute {
	NSMutableDictionary *dict = [NSMutableDictionary dictionary];
	RKUserConfiguration *config = [RKUserConfiguration sharedInstance];
	dict[NSForegroundColorAttributeName] = [UIColor colorWithHexString:config.fontColor];
	dict[NSFontAttributeName] = [UIFont systemFontOfSize:config.fontSize];
	NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
	paragraphStyle.lineSpacing = config.lineSpace;
	paragraphStyle.alignment = NSTextAlignmentJustified;
	dict[NSParagraphStyleAttributeName] = paragraphStyle;
	return [dict copy];
}

@end
