//
//  RKBookChapter.m
//  RKReader
//
//  Created by RZK on 2018/9/8.
//  Copyright © 2018年 Rzk. All rights reserved.
//

#import "RKBookChapter.h"
#import <CoreText/CoreText.h>

@interface RKBookChapter ()

@property (nonatomic,strong) NSMutableArray *pageArray; /**< 分页内容 */

@end

@implementation RKBookChapter
- (instancetype)init
{
	self = [super init];
	if (self) {
		_pageArray = [NSMutableArray array];
	}
	return self;
}

#pragma mark - setting
- (void)setContent:(NSString *)content {
	_content = content;
	
	// 根据内容分页
	[self paginateWithBounds:self.contentFrame];
}

#pragma mark - 函数
/// 修改字号
- (void)updateFont {
	[self paginateWithBounds:self.contentFrame];
}

- (NSString *)stringOfPage:(NSUInteger)index {
	NSUInteger local = [self.pageArray[index] integerValue];
	NSUInteger length;
	if (index < self.pageCount - 1 ) {
		length = [self.pageArray[index+1] integerValue] - [self.pageArray[index] integerValue];
	} else {
		length = self.content.length - [self.pageArray[index] integerValue];
	}
	return [self.content substringWithRange:NSMakeRange(local, length)];
}

- (void)paginateWithBounds:(CGRect)bounds {
	[self.pageArray removeAllObjects];
	NSAttributedString *attrString;
	CTFramesetterRef frameSetter;
	CGPathRef path;
	NSMutableAttributedString *attrStr;
	attrStr = [[NSMutableAttributedString  alloc] initWithString:self.content];
	NSDictionary *attribute = [[RKUserConfiguration sharedInstance] parserAttribute];
	[attrStr setAttributes:attribute range:NSMakeRange(0, attrStr.length)];
	attrString = [attrStr copy];
	frameSetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) attrString);
	path = CGPathCreateWithRect(bounds, NULL);
	int currentOffset = 0;
	int currentInnerOffset = 0;
	BOOL hasMorePages = YES;
	// 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
	int preventDeadLoopSign = currentOffset;
	int samePlaceRepeatCount = 0;
	
	while (hasMorePages) {
		if (preventDeadLoopSign == currentOffset) {
			++samePlaceRepeatCount;
		} else {
			samePlaceRepeatCount = 0;
		}
		if (samePlaceRepeatCount > 1) {
			// 退出循环前检查一下最后一页是否已经加上
			if (self.pageArray.count == 0) {
				[self.pageArray addObject:@(currentOffset)];
			}
			else {
				NSUInteger lastOffset = [[self.pageArray lastObject] integerValue];
				if (lastOffset != currentOffset) {
					[self.pageArray addObject:@(currentOffset)];
				}
			}
			break;
		}
		
		[self.pageArray addObject:@(currentOffset)];
		
		CTFrameRef frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, NULL);
		CFRange range = CTFrameGetVisibleStringRange(frame);
		if ((range.location + range.length) != attrString.length) {
			currentOffset += range.length;
			currentInnerOffset += range.length;
		} else {
			// 已经分完，提示跳出循环
			hasMorePages = NO;
		}
		if (frame) CFRelease(frame);
	}
	
	CGPathRelease(path);
	CFRelease(frameSetter);
	self.pageCount = self.pageArray.count;
}

@end
