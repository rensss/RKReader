//
//  RKBottomStatusBar.m
//  RKReader
//
//  Created by MBP on 2018/9/13.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKBottomStatusBar.h"

@interface RKBottomStatusBar ()

@property (nonatomic, strong) RKBookChapter *chapter; /**< 当前章节*/
@property (nonatomic, strong) RKHomeListBooks *book; /**< 当前书籍对象*/

@property (nonatomic, strong) UIImageView *batteryImage; /**< 电池*/
@property (nonatomic, strong) UILabel *batteryNum; /**< 电量*/
@property (nonatomic, strong) UILabel *bookName; /**< 书名+页码*/
@property (nonatomic, strong) UILabel *progress; /**< 进度*/

@end

@implementation RKBottomStatusBar

- (instancetype)initWithFrame:(CGRect)frame and:(RKHomeListBooks *)book and:(RKBookChapter *)chapter
{
    self = [super initWithFrame:frame];
    if (self) {
        _book = book;
        _chapter = chapter;
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2f];
        
        [self addSubview:self.batteryImage];
        [self addSubview:self.batteryNum];
        [self addSubview:self.bookName];
        [self addSubview:self.progress];
    }
    return self;
}

- (void)layoutSubviews {
    [self.batteryNum sizeToFit];
    self.batteryNum.centerY = self.batteryImage.centerY = self.height/2;
    self.batteryNum.x = self.batteryImage.maxX + 2;
    self.bookName.centerX = self.width/2;
}

- (void)drawRect:(CGRect)rect {
    
    NSInteger batteryLevel = [self getCurrentBatteryLevel];
    self.batteryNum.text = [NSString stringWithFormat:@"%ld",batteryLevel];
    
    NSString *batteryName = @"battery";
    if (batteryLevel < 10) {
        batteryName = [batteryName stringByAppendingString:@"0"];
    }
    if (batteryLevel <= 20) {
        batteryName = [batteryName stringByAppendingString:@"1"];
    }
    if (batteryLevel <= 40) {
        batteryName = [batteryName stringByAppendingString:@"2"];
    }
    if (batteryLevel <= 60) {
        batteryName = [batteryName stringByAppendingString:@"3"];
    }
    if (batteryLevel <= 80) {
        batteryName = [batteryName stringByAppendingString:@"4"];
    }
    if (batteryLevel > 80) {
        batteryName = [batteryName stringByAppendingString:@"5"];
    }
    
    // 电池
    self.batteryImage.image = [UIImage imageNamed:batteryName];
}

#pragma mark - 函数
- (int)getCurrentBatteryLevel {
    UIApplication *app = [UIApplication sharedApplication];
    if (app.applicationState == UIApplicationStateActive || app.applicationState == UIApplicationStateInactive) {
        Ivar ivar = class_getInstanceVariable([app class],"_statusBar");
        id status = object_getIvar(app, ivar);
        for (id aview in [status subviews]) {
            int batteryLevel = 0;
            for (id bview in [aview subviews]) {
                if ([NSStringFromClass([bview class]) caseInsensitiveCompare:@"UIStatusBarBatteryItemView"] == NSOrderedSame&&[[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0)
                {
                    
                    Ivar ivar=  class_getInstanceVariable([bview class],"_capacity");
                    if (ivar) {
                        batteryLevel = ((int (*)(id, Ivar))object_getIvar)(bview, ivar);
                        //这种方式也可以
                        /*ptrdiff_t offset = ivar_getOffset(ivar);
                         unsigned char *stuffBytes = (unsigned char *)(__bridge void *)bview;
                         batteryLevel = * ((int *)(stuffBytes + offset));*/
                        RKLog(@"电池电量 -- %d%%",batteryLevel);
                        if (batteryLevel > 0 && batteryLevel <= 100) {
                            return batteryLevel;
                        } else {
                            return 0;
                        }
                    }
                }
            }
        }
    }
    
    return 0;
}

#pragma mark - getting
- (UIImageView *)batteryImage {
    if (!_batteryImage) {
        _batteryImage = [[UIImageView alloc] initWithFrame:CGRectMake(3, 0, 18, 10)];
        _batteryImage.image = [UIImage imageNamed:@"battery5"];
    }
    return _batteryImage;
}

- (UILabel *)batteryNum {
    if (!_batteryNum) {
        _batteryNum = [[UILabel alloc] initWithFrame:CGRectMake(self.batteryImage.maxX + 2, 0, 30, 10)];
        _batteryNum.text = @"100";
        _batteryNum.font = [UIFont systemFontOfSize:10];
        _batteryNum.textColor = kReadViewBottomTintColor;
    }
    return _batteryNum;
}

- (UILabel *)bookName {
    if (!_bookName) {
        _bookName = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 280, self.height)];
        _bookName.font = [UIFont systemFontOfSize:10];
        _bookName.textColor = kReadViewBottomTintColor;
        _bookName.textAlignment = NSTextAlignmentCenter;
        _bookName.text = [NSString stringWithFormat:@"%@(%ld/%ld)",self.book.fileInfo.fileName,self.book.readProgress.chapter,self.chapter.pageCount];
    }
    return _bookName;
}

- (UILabel *)progress {
    if (!_progress) {
        _progress = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, self.height)];
        _progress.maxX = self.width - 3;
        _progress.font = [UIFont systemFontOfSize:10];
        _progress.textColor = kReadViewBottomTintColor;
        _progress.textAlignment = NSTextAlignmentRight;
        _progress.text = @"0.00%";
    }
    return _progress;
}

@end